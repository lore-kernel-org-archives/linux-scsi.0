From: Andrei Tanas <andrei@tanas.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Fri, 04 Sep 2009 15:39:07 -0400
Message-ID: <a336bb4e539047cf95294507a3c81ba2@localhost>
References: <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BC033.9000909@pobox.com> <4A9C60A1.50303@rtr.ca> <640f6103c45b6cba6f84f887bde227e4@localhost> <20090902215841.GA12441@lifeintegrity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090902215841.GA12441@lifeintegrity.com>
Sender: linux-ide-owner@vger.kernel.org
To: Allan Wind <allan_wind@lifeintegrity.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2 Sep 2009 17:58:41 -0400, Allan Wind
<allan_wind@lifeintegrity.com>
wrote:
> On 2009-09-01T09:07:11, Andrei Tanas wrote:
>> Mine errored out again with exactly the same symptoms, this time after
>> only
>> few days and with the "tunable" set to 2 sec. I got a warranty
>> replacement
>> but haven't shipped this one yet. Let me know if you want it.
> 
> How do you set it to 2 sec?  I have a raid 1 array of two new WDC 
> 2 TB drives that fail on the 2nd drive all the time.  Disabling 
> NCQ might have helped but it is hard to tell.  It was stable for 
> a week, but probably failed 10 times over the weekend.  I either 
> need to add a 3rd drive to get any protection from hardware 
> failure, or use lvm to mirror the two drives instead of md :-(

echo 2.0 > /sys/block/md0/md/safe_mode_delay
