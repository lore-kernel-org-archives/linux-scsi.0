From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: Thu, 8 Jan 2004 11:57:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040108195732.GB10391@beaverton.ibm.com>
References: <B179AE41C1147041AA1121F44614F0B060EDD4@AVEXCH02.qlogic.org> <20040108165414.A12233@infradead.org> <20040108193336.GB10243@beaverton.ibm.com> <20040108193427.A14545@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040108193427.A14545@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> > Also some partial information of the other hba api
> > functions could be supported though other sysfs attributes but the sends
> > would still need to use the old interface.
> 
> With sends are you referring to function that support certain scsi
> commands like report luns and report capacity?  We have a perfectly
> fine interface for that and it's SG_IO.. 

I was thinking about the fabric management functions section of the
spec. I would believe that the SG_IO should be able to handle the SCSI
information functions section (though I have used this interface very
little).

-andmike
--
Michael Anderson
andmike@us.ibm.com
