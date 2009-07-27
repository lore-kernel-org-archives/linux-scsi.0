From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
Date: Mon, 27 Jul 2009 17:51:23 +0300
Message-ID: <4A6DBEEB.5020302@panasas.com>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>	<yq1hbwykj80.fsf@sermon.lab.mkp.net>	<20090727020611.GC3711@parisc-linux.org>	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com> <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752612AbZG0Ovf@vger.kernel.org>
In-Reply-To: <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/27/2009 05:29 PM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> I don't understand. The device in question breaks when we try to
> Boaz> read a page that it reported it supports?
> 
> No.  The USB-ATA bridge in question locks up when we send it an INQUIRY
> with EVPD=1.  I.e. when we try to get a list of pages. 0xB0 and 0xB1 are
> not even in play here.
> 

Haa, OK. I thought INQUIRY EVPD=1 page=0 was so old it sure must be supported
but you are saying it's only SBC2/SPC3. So I guess there is nothing else we can do.

What I hate about all this is that in USB the scsi_level is hard coded at the driver,
without actually been able to probe the device about it. So my 1 TeraByte new seagate
external disk must behave like the above junk.
(Thank god for eSATA)

Boaz
