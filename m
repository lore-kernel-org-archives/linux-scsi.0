From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2] scsi: sr: use block layer runtime PM
Date: Sat, 07 Sep 2013 22:45:44 +0800
Message-ID: <522B3C18.6060304@intel.com>
References: <Pine.LNX.4.44L0.1309051007220.1121-100000@iolanthe.rowland.org>  <52293763.5070206@intel.com> <1378479604.2063.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1378479604.2063.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-pm-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2013 11:00 PM, James Bottomley wrote:
> On Fri, 2013-09-06 at 10:01 +0800, Aaron Lu wrote:
>> Migrate SCSI Optical Disk Drive(ODD)
> 
> I'm not very keen on this description because it's not quite accurate.
> sr stands for SCSI ROM.  You could say optical SCSI ROM perhaps, but
> Magneto Optical disks are handled by sd not sr.
> 
>>  driver sr to make use of block
> 
> I'd just say "Migrate sr to make use of .."

OK, will update in v3, thanks for the correction.

Thanks,
Aaron
