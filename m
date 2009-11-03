From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] qlogicpti: add missing parentheses
Date: Tue, 03 Nov 2009 17:51:49 -0600
Message-ID: <1257292309.2454.54.camel@mulgrave.site>
References: <4AF0BF04.9030203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753676AbZKCXvx@vger.kernel.org>
In-Reply-To: <4AF0BF04.9030203@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-11-04 at 00:38 +0100, Roel Kluin wrote:
> `+' has a higher precedence than `?' so the condition always
> evaluates to true and this is preprocessed to `7*((ql) - 1)'
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/qlogicpti.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> This one must be right, I think.

It looks plausible ... but it will increase the mailbox segment length
by 4 ... someone needs to verify that this increase will actually work
and won't run off the end of the mailbox table.

James
