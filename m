From: Chris Murphy <lists@colorremedies.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would cause this?
Date: Thu, 6 Dec 2012 13:27:54 -0700
Message-ID: <DCD9A122-21A1-45D7-B872-84F5FDA8FB4F@colorremedies.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>		<50B67230.4080602@genband.com>	 <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com>	 <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com>	 <50BD0F44.7010808@genband.com> <50BD1127.6090304@redhat.com>	 <50BD14B1.7000203@genband.com> <50BD1F45.1040802@redhat.com>	 <50BE7293.8060200@genband.com> <1354699254.2243.5.camel@dabdike.int.hansenpartnership.com> <50C0E0C4.9050400@genband.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50C0E0C4.9050400@genband.com>
Sender: linux-ide-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Dec 6, 2012, at 11:15 AM, Chris Friesen <chris.friesen@genband.com> wrote:
>> 
> 
> So it turns out that our problems are intermittently triggered when running the default self test.  This agrees with the statement in sg_senddiag to not do foreground self-tests on disks with mounted filesystems.

Yeah that would be a bad idea. But the default SMART test isn't with the -C flag (for foreground testing), it's a background test including the long/extended test.


Chris Murphy

