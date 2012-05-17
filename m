From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] st: Use static class attributes
Date: Thu, 17 May 2012 08:32:46 +0100
Message-ID: <1337239966.2926.1.camel@dabdike.int.hansenpartnership.com>
References: <4FB476DD.4020107@suse.com> <4FB4782F.9080907@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FB4782F.9080907@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-16 at 21:01 -0700, Lee Duncan wrote:
> Sorry. This is actually
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> 
> Apologies. The other patches in the set are labeled correctly.

Actually, no, in this case, I need a From: field at the top as well for
the author.

You obviously used git to generate them, so either

git show --pretty=email

or

git format-patch -k

Will produce the right form

James
