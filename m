From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3 ] SCSI: Support several features in arcmsr driver
Date: Tue, 13 Apr 2010 13:10:37 -0700
Message-ID: <20100413131037.96a0bb77.akpm@linux-foundation.org>
References: <9887B6161072481EB07AF9A0A8B7D5A8@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9887B6161072481EB07AF9A0A8B7D5A8@areca4e4f859d4>
Sender: linux-kernel-owner@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 9 Apr 2010 10:24:19 +0800
"Nick Cheng" <nick.cheng@areca.com.tw> wrote:

> 1. To support instantaneous report for SCSI device existing by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
> 
> 
> [patch1  application/octet-stream (39.7KB)]

Lots of problems here.

- Two of the patches had the same title ("SCSI: Support several
  features in arcmsr driver").  Please ensure that each patch has a
  unique and well-chosen title.

- application/octet-stream attachments are hard for people to read
  in-line in mail clients.  Please at least use text/plain MIME type if
  possible.

- The patches aren't in `patch -p1' form.  You had

	--- arcmsr/arcmsr_attr.c
	+++ arcmsr.1.20.00.15-81103/arcmsr_attr.c

  which cannot be applied from the top-level of the kernel tree.  It
  should have been

	--- a/drivers/scsi/arcmsr/arcmsr_attr.c
	+++ a/drivers/scsi/arcmsr/arcmsr_attr.c

  or similar.

I got all that fixed up, but when applying the second patch (using
2.6.34-rc4) I encountered a large number of patch rejects and gave up.

So please fix all that up and resend.  Perhaps you could use
http://savannah.nongnu.org/projects/quilt which automates all this.

Also, please run scripts/checkpatch.pl across the patches - it reports
rather a lot of minor issues which you might choose to address.

Thanks.
