From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Kernel 2.6.20.4: Software RAID 5: ata13.00: (irq_stat 0x00020002,
 failed to transmit command FIS)
Date: Thu, 5 Apr 2007 12:47:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704051243080.3810@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Had a quick question, this is the first time I have seen this happen, and 
it was not even under during heavy I/O, hardly anything was going on with 
the box at the time.

Any idea what could have caused this?  I am running a badblocks test right 
now, but so far the disk looks OK.

[369143.916093] ata13.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[369143.916100] ata13.00: (irq_stat 0x00020002, failed to transmit command FIS)
[369143.916107] ata13.00: cmd ca/00:00:97:1a:d5/00:00:00:00:00/e9 tag 0 cdb 0x0 data 131072 out
[369143.916109]          res 93/37:00:00:00:00/00:00:40:00:93/00 Emask 0x12 (ATA bus error)
[369143.916116] ata13: hard resetting port
[369146.145915] ata13: softreset failed (port not ready)
[369146.145922] ata13: follow-up softreset failed, retrying in 5 secs
[369151.146035] ata13: hard resetting port
[369153.376736] ata13: softreset failed (port not ready)
[369153.376743] ata13: follow-up softreset failed, retrying in 5 secs
[369158.376664] ata13: hard resetting port
[369160.608025] ata13: softreset failed (port not ready)
[369160.608033] ata13: reset failed, giving up
[369160.608036] ata13.00: disabled
[369160.608043] ata13: EH pending after completion, repeating EH (cnt=4)
[369160.718365] ata13: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0x6 frozen
[369160.718370] ata13: (irq_stat 0x00060002, failed to transmit command FIS)
[369161.238432] ata13: waiting for device to spin up (8 secs)
[369168.715610] ata13: hard resetting port
[369170.946658] ata13: softreset failed (port not ready)
[369170.946666] ata13: follow-up softreset failed, retrying in 5 secs
[369175.946249] ata13: hard resetting port
[369178.167644] ata13: softreset failed (port not ready)
[369178.167651] ata13: follow-up softreset failed, retrying in 5 secs
[369183.167742] ata13: hard resetting port
[369185.398497] ata13: softreset failed (port not ready)
[369185.398504] ata13: reset failed, giving up
[369185.398522] sd 12:0:0:0: SCSI error: return code = 0x08000002
[369185.398526] sdl: Current [descriptor]: sense key: Aborted Command
[369185.398532]     Additional sense: Scsi parity error
[369185.398539] Descriptor sense data with sense descriptors (in hex):
[369185.398544]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[369185.398572]         00 00 00 00 
[369185.398581] end_request: I/O error, dev sdl, sector 164960919
[369185.398586] raid5: Disk failure on sdl1, disabling device. Operation continuing on 3 devices
[369185.398617] sd 12:0:0:0: rejecting I/O to offline device
[369185.398625] ata13: EH complete
[369185.398635] ata13.00: detaching (SCSI 12:0:0:0)
[369185.398676] sd 12:0:0:0: SCSI error: return code = 0x00010000
[369185.398680] end_request: I/O error, dev sdl, sector 164961175
[369185.398702] raid5:md3: read error not correctable (sector 164962304 on sdl1).
[369185.398707] raid5:md3: read error not correctable (sector 164962312 on sdl1).
[369185.398711] raid5:md3: read error not correctable (sector 164962320 on sdl1).
[369185.398716] raid5:md3: read error not correctable (sector 164962328 on sdl1).
[369185.398760] Synchronizing SCSI cache for disk sdl: 
[369185.398784] FAILED
[369185.398785]   status = 0, message = 00, host = 4, driver = 00
[369185.398786]   <3>scsi 12:0:0:0: rejecting I/O to dead device
[369185.404619] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404641] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404662] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404682] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404686] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404691] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404712] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404732] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404753] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404774] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404794] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404815] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404844] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404863] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404882] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404900] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404918] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404937] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404956] scsi 12:0:0:0: rejecting I/O to dead device
[369185.413938] RAID5 conf printout:
[369185.413944]  --- rd:4 wd:3
[369185.413948]  disk 0, o:1, dev:sdi1
[369185.413950]  disk 1, o:1, dev:sdj1
[369185.413953]  disk 2, o:0, dev:sdl1
[369185.413956]  disk 3, o:1, dev:sdg1
[369185.418873] RAID5 conf printout:
[369185.418878]  --- rd:4 wd:3
[369185.418881]  disk 0, o:1, dev:sdi1
[369185.418884]  disk 1, o:1, dev:sdj1
[369185.418887]  disk 3, o:1, dev:sdg1

Relevant SMART data:

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always 
-       0
   3 Spin_Up_Time            0x0007   192   165   021    Pre-fail  Always 
-       3441
   4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always 
-       34
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always 
-       0
   7 Seek_Error_Rate         0x000a   200   200   051    Old_age   Always 
-       0
   9 Power_On_Hours          0x0032   098   098   000    Old_age   Always 
-       1988
  10 Spin_Retry_Count        0x0012   100   253   051    Old_age   Always 
-       0
  11 Calibration_Retry_Count 0x0012   100   253   051    Old_age   Always 
-       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always 
-       34
194 Temperature_Celsius     0x0022   120   107   000    Old_age   Always 
-       27
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always 
-       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always 
-       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always 
-       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always 
-       1
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age   Offline 
-       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      1977 
-
# 2  Short offline       Completed without error       00%      1954 
-
# 3  Short offline       Completed without error       00%      1931 
-
# 4  Short offline       Completed without error       00%      1908 
-
# 5  Short offline       Completed without error       00%      1861 
-
# 6  Short offline       Completed without error       00%      1814 
-
# 7  Short offline       Completed without error       00%      1791 
-
# 8  Short offline       Completed without error       00%      1768 
-
# 9  Short offline       Completed without error       00%      1745 
-
#10  Short offline       Completed without error       00%      1698 
-
#11  Short offline       Completed without error       00%      1651 
-
#12  Short offline       Completed without error       00%      1628 
-
#13  Short offline       Completed without error       00%      1605 
-
#14  Short offline       Completed without error       00%      1581 
-
#15  Short offline       Completed without error       00%      1535 
-
#16  Short offline       Completed without error       00%      1488 
-
#17  Short offline       Completed without error       00%      1464 
-
#18  Short offline       Completed without error       00%      1441 
-
#19  Short offline       Completed without error       00%      1418 
-
#20  Short offline       Completed without error       00%      1372 
-
#21  Short offline       Completed without error       00%      1326 
-

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute 
delay.


