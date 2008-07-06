From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCHSET 2.6.26-rc8] block: implement extended devt
Date: Sun, 06 Jul 2008 23:37:59 +0900
Message-ID: <4870D8C7.6080100@gmail.com>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> This patchset implements extended devt for block devices.  This is
> mainly to work around sd limitations (16 minors per device) but can
> easily be used to allow more partitions or more devices.

I'm updating the patchset.  Please standby a bit.

Thanks.

-- 
tejun
