From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14653] New: sysfs: cannot create duplicate filename
 '/bus/scsi/drivers/sd/2:0:1:0'
Date: Sat, 21 Nov 2009 13:13:37 GMT
Message-ID: <bug-14653-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44744 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZKUNNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 08:13:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nALDDbHa028745
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2009 13:13:37 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14653

           Summary: sysfs: cannot create duplicate filename
                    '/bus/scsi/drivers/sd/2:0:1:0'
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: olel@ans.pl
        Regression: No


sd 2:0:1:0: emc: connected to SP B Port 5 (bound, default SP A)
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x85/0x99()
Hardware name: PowerEdge 1950
sysfs: cannot create duplicate filename '/bus/scsi/drivers/sd/2:0:1:0'
Pid: 795, comm: scsi_wq_2 Not tainted 2.6.31.6-o0 #1
Call Trace:
 [<ffffffff810e32fe>] ? sysfs_add_one+0x85/0x99
 [<ffffffff8103b82f>] ? warn_slowpath_common+0x72/0x9e
 [<ffffffff8103b8b7>] ? warn_slowpath_fmt+0x51/0x59
 [<ffffffff812fa3e4>] ? ida_get_new_above+0xf5/0x1b3
 [<ffffffff810e3271>] ? sysfs_pathname+0x35/0x3d
 [<ffffffff810e3271>] ? sysfs_pathname+0x35/0x3d
 [<ffffffff810e3271>] ? sysfs_pathname+0x35/0x3d
 [<ffffffff810e3271>] ? sysfs_pathname+0x35/0x3d
 [<ffffffff810e32fe>] ? sysfs_add_one+0x85/0x99
 [<ffffffff810e4051>] ? sysfs_do_create_link+0xba/0x11c
 [<ffffffff813996bb>] ? driver_sysfs_add+0x22/0x63
 [<ffffffff81399947>] ? device_bind_driver+0xe/0x23
 [<ffffffff81399986>] ? device_attach+0x2a/0x63
 [<ffffffff81398ce1>] ? bus_probe_device+0x1f/0x38
 [<ffffffff81397a34>] ? device_add+0x464/0x5b1
 [<ffffffff8139be76>] ? transport_configure+0x0/0x17
 [<ffffffff8139bb90>] ? attribute_container_device_trigger+0x99/0xa4
 [<ffffffff813a9572>] ? scsi_sysfs_add_sdev+0xaf/0x241
 [<ffffffff813a762e>] ? scsi_probe_and_add_lun+0x8d3/0xa17
 [<ffffffff81396f61>] ? get_device+0x14/0x1b
 [<ffffffff813a6994>] ? scsi_alloc_target+0x252/0x28f
 [<ffffffff813a796e>] ? __scsi_scan_target+0xb3/0x541
 [<ffffffff815b1182>] ? _spin_unlock_irq+0x11/0x2b
 [<ffffffff81035545>] ? finish_task_switch+0x5d/0xbd
 [<ffffffff815afd1c>] ? __mutex_lock_slowpath+0x261/0x287
 [<ffffffff813a8356>] ? scsi_scan_target+0x92/0xb1
 [<ffffffff813b09c8>] ? fc_scsi_scan_rport+0x0/0x99
 [<ffffffff813b0a42>] ? fc_scsi_scan_rport+0x7a/0x99
 [<ffffffff8104990d>] ? worker_thread+0xec/0x194
 [<ffffffff8104ce98>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81049821>] ? worker_thread+0x0/0x194
 [<ffffffff8104cba1>] ? kthread+0x8b/0x93
 [<ffffffff8100c94a>] ? child_rip+0xa/0x20
 [<ffffffff8104cb16>] ? kthread+0x0/0x93
 [<ffffffff8100c940>] ? child_rip+0x0/0x20
---[ end trace 8aac874df8e186c3 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
