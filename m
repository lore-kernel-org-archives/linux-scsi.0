From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] iSCSI-target: Use common error handling code in
 iscsi_decode_text_input()
Date: Mon, 6 Nov 2017 16:25:49 +0000
Message-ID: <20171106162549.5b2511db@alans-desktop>
References: <d36d5072-3e35-da39-bc0f-af15deb630a8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d36d5072-3e35-da39-bc0f-af15deb630a8@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 3 Nov 2017 22:33:08 +0100
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 3 Nov 2017 22:20:38 +0100
> 
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function.

Why not look at what the C compiler generates before making the code less
readable ?

Alan
