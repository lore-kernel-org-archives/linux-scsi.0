From: Tim Small <tim@buttersideup.com>
Subject: Re: Apparent MPT ata pass-through bug
 SAS1068 and SAS1068E - WAS SMART causes disks to go offline on an LSI
 SAS1068 controller - Dell	SAS 5/iR
Date: Thu, 29 Oct 2009 09:01:39 +0000
Message-ID: <4AE959F3.8070104@buttersideup.com>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu>	<4AE72E40.2000903@seoss.co.uk>
	<4AE8448C.6070709@seoss.co.uk>	<0D1E8821739E724A86F4D16902CE275C1C93A02A34@inbmail01.lsi.com>
	<4AE877D3.4040300@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <smartmontools-support-bounces@lists.sourceforge.net>
In-Reply-To: <4AE877D3.4040300@seoss.co.uk>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/smartmontools-support>,
	<mailto:smartmontools-support-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=smartmontools-support>
List-Post: <mailto:smartmontools-support@lists.sourceforge.net>
List-Help: <mailto:smartmontools-support-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/smartmontools-support>,
	<mailto:smartmontools-support-request@lists.sourceforge.net?subject=subscribe>
Errors-To: smartmontools-support-bounces@lists.sourceforge.net
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, "smartmontools-support@lists.sourceforge.net" <smartmontools-support@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-PowerEdge@dell.com" <Linux-PowerEdge@dell.com>
List-Id: linux-scsi@vger.kernel.org

Tim Small wrote:
> 2.6.32-rc4 with mptsas 3.04.13.  I'm running the smartctl -a in a loop 
> at the moment and will leave it running over-night

Hasn't crashed yet (15 hrs).  The following has been logged however,
which looks like ATA pass-through isn't work right to me...

[   22.414415] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
9, phy 0, sas_addr 0x1221000000000000
[   22.466953] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
1, phy 1, sas_addr 0x1221000001000000
[   22.519305] mptsas: ioc0: attaching raid volume, channel 1, id 0
[   33.727405] Fusion MPT misc device (ioctl) driver 3.04.13
[   33.738270] mptctl: Registered with Fusion MPT base driver
[   33.749277] mptctl: /dev/mptctl @ (major,minor=10,220)
[ 5300.611795] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.629028] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.646254] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.663478] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.680700] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.697924] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5312.111795] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[ 5312.131469] mptscsih: ioc0: attempting task abort! (sc=ffff88012c5fc8c0)
[ 5312.156831] mptscsih: ioc0: task abort: FAILED (sc=ffff88012c5fc8c0)
[ 5312.169534] mptscsih: ioc0: attempting target reset!
(sc=ffff88012c5fc8c0)
[ 5312.195222] mptscsih: ioc0: target reset: FAILED (sc=ffff88012c5fc8c0)
[ 5312.208276] mptscsih: ioc0: attempting bus reset! (sc=ffff88012c5fc8c0)
[ 5316.612245] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88012c5fc8c0)
[ 5328.112389] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[ 5328.128508] mptscsih: ioc0: attempting host reset! (sc=ffff88012c5fc8c0)
[12537.867482] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[12537.885769] mptscsih: ioc0: attempting host reset! (sc=ffff88012d55c8c0)
[12537.899173] mptbase: ioc0: Initiating recovery
[12559.704264] mptscsih: ioc0: host reset: SUCCESS (sc=ffff88012d55c8c0)
[44184.424640] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[44184.441866] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[44195.924782] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[44195.944449] mptscsih: ioc0: attempting task abort! (sc=ffff88012c403ac0)
[44195.969799] mptscsih: ioc0: task abort: FAILED (sc=ffff88012c403ac0)
[44195.982500] mptscsih: ioc0: attempting target reset!
(sc=ffff88012c403ac0)
[44196.008182] mptscsih: ioc0: target reset: FAILED (sc=ffff88012c403ac0)
[44196.021230] mptscsih: ioc0: attempting bus reset! (sc=ffff88012c403ac0)
[44200.425026] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88012c403ac0)
[44211.925127] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[44211.943416] mptscsih: ioc0: attempting host reset! (sc=ffff88012c403ac0)
[44211.956814] mptbase: ioc0: Initiating recovery
[44233.760010] mptscsih: ioc0: host reset: SUCCESS (sc=ffff88012c403ac0)
[49878.447977] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[49889.948381] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[49889.968080] mptscsih: ioc0: attempting task abort! (sc=ffff88003799acc0)
[49889.993425] mptscsih: ioc0: task abort: FAILED (sc=ffff88003799acc0)
[49890.006129] mptscsih: ioc0: attempting target reset!
(sc=ffff88003799acc0)
[49890.031817] mptscsih: ioc0: target reset: FAILED (sc=ffff88003799acc0)
[49890.044869] mptscsih: ioc0: attempting bus reset! (sc=ffff88003799acc0)
[49894.448617] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88003799acc0)
[49905.948189] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[49905.966491] mptscsih: ioc0: attempting host reset! (sc=ffff88003799acc0)
[49905.979888] mptbase: ioc0: Initiating recovery



... I will impose a bit of extra IO load on the machine to see if that
provokes more errors.

Thanks,

Tim.

------------------------------------------------------------------------------
Come build with us! The BlackBerry(R) Developer Conference in SF, CA
is the only developer event you need to attend this year. Jumpstart your
developing skills, take BlackBerry mobile applications to market and stay 
ahead of the curve. Join us from November 9 - 12, 2009. Register now!
http://p.sf.net/sfu/devconference
