From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6.14-rc1] sym scsi boot hang
Date: Tue, 13 Sep 2005 11:35:44 -0500
Message-ID: <1126629345.4809.36.camel@mulgrave>
References: <20050913124804.GA5008@in.ibm.com>
	 <20050913131739.GD26162@krispykreme>  <20050913142939.GE26162@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964872AbVIMQgH@vger.kernel.org>
In-Reply-To: <20050913142939.GE26162@krispykreme>
Sender: linux-kernel-owner@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2005-09-14 at 00:29 +1000, Anton Blanchard wrote:
> I just noticed a similar hang on the ibmvscsi driver. The following
> backout patch seems to fix it (part of the scsi merge yesterday), I'll
> look closer after I get some sleep.

If that's the cause, it's probably a double down of the host scan
semaphore somewhere in the code.  alt-sysrq-t should work in this case,
can you get a stack trace of the blocked process?

Thanks,

James
