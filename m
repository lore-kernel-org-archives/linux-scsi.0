From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5]  arcmsr: Re-name the HBA Type
Date: Tue, 13 Nov 2012 13:39:57 +0000
Message-ID: <1352813997.2505.10.camel@dabdike.sthat4.btopenzone.com>
References: <E0E58D26E0F44C3580C13BBDE76CBB5D@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E0E58D26E0F44C3580C13BBDE76CBB5D@arecaaebe11fae>
Sender: linux-kernel-owner@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-10-12 at 17:05 +0800, NickCheng wrote:
> -#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK        0x00000004 /*
> When clear, the General Outbound Doorbell interrupt routes to
> the host.*/
> 
The patch is still linebroken here.  It is a massively long line (like
about 200 characters).  I suspect you just set your exchange server line
break to something big, but not bigger than this?

James
