From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
Date: Thu, 09 Apr 2009 16:42:24 -0400
Message-ID: <49DE5DB0.3030209@garzik.org>
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org> <49DE2905.3030102@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49DE2905.3030102@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> a single utility should be used to configure a SATA+SAS controller 
>> port.  Requiring use of hdparm when the port is in SATA mode, and sg_* 
>> when the port is in SAS mode, is a bit annoying.
> ..
> 
> That's why hdparm uses sg_* whenever possible already.

Does hdparm really call out to external applications sg_senddiag, 
sg_opcodes, sg_inq, sg_turs, etc.?

	Jeff



