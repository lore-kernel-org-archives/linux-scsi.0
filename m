From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Recovered disk error caused disk to go offline.
Date: Fri, 30 Jan 2004 14:33:38 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yqujk739dvml.fsf@chaapala-lnx2.cisco.com>
References: <200401301902.i0UJ2Ai30922@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401301902.i0UJ2Ai30922@dns1.watkins-home.com> (Guy's
 message of "Fri, 30 Jan 2004 14:02:10 -0500")
To: Guy <bugzilla@watkins-home.com>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

iSCSI acts as another HBA, and conveys status up from the [Fibre
Channel] devices to the scsi layer.  SCSI reported that event, and the
raid system rolled over the disk to another, more reliable, one.
Wouldn't that be correct behavior for Raid?  Cc-ing linux-raid...

On Fri, 30 Jan 2004, Guy verbalised:
> Sorry about the re-post, but no comments after almost 2 days.
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Guy
> Sent: Thursday, January 29, 2004 12:21 AM
> To: linux-scsi@vger.kernel.org
> Subject: Recovered disk error caused disk to go offline.
> 
> Neil Brown said to send this message to linux-scsi, so here it is.
> 
> Please help.
> Thanks,
> Guy
> 
> On Thursday January 29, bugzilla@watkins-home.com wrote:
>> As you can see in the log, the write error recovered with auto
> reallocation!
>> As I understand it, this is a normal event with today's disks.
>> I don't think the disk should have been considered failed.
>> 
>> Comments please?
> 
> You need to talk to linux-scsi about this.  The scsi subsystem told
> the raid subsystem that there was an error, so the raid subsystem
> stopped using the device.
> 
> If the write error was recovered, scsi shouldn't have reported an
> error to raid.
> 
> NeilBrown
> 
>> 
>> Thanks,
>> Guy
>> 
>> The spare disk resynced just fine..,A I never knew for over 24
>> hours!  This is cool stuff!
>> 
>> Jan 27 12:44:06 watkins kernel: SCSI disk error : host 2 channel 0
>> id 4
> lun
>> 0 return code = 8000002 Jan 27 12:44:06 watkins kernel: Info
>> fld=0x7e5c81, Deferred sd08:71: sense key Recovered Error Jan 27
>> 12:44:06 watkins kernel: Additional sense indicates Write error -
>> recovered with auto reallocation Jan 27 12:44:06 watkins kernel:.,A
>> I/O error: dev 08:71, sector 8280704 Jan 27 12:44:06 watkins
>> kernel: raid5: Disk failure on sdh1, disabling device. Operation
>> continuing on 13 devices Jan 27 12:44:06 watkins kernel: md:
>> updating md2 RAID superblock on device Jan 27 12:44:06 watkins
>> kernel: md: sdc1 [events: 00000009]<6>(write)
> sdc1's
>> sb offset: 17767744 Jan 27 12:44:06 watkins kernel: md: recovery
>> thread got woken up ...  Jan 27 12:44:06 watkins kernel: md2:
>> resyncing spare disk sdc1 to replace failed disk Jan 27 12:44:06
>> watkins kernel: RAID5 conf printout: Jan 27 12:44:06 watkins
>> kernel:.,A --- rd:14 wd:13 fd:1
>> 
>> - To unsubscribe from this list: send the line "unsubscribe
>> linux-raid" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> - To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 
> - To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 
> - To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
             Minnesota, a quite agreeable state.  Lately,
             Celsius and Fahrenheit have tended to agree.
