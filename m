From: Christian Iversen <chrivers@iversen-net.dk>
Subject: (unknown)
Date: Thu, 18 Nov 2004 19:52:46 +0100
Message-ID: <200411181952.46993.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:35654 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S262882AbUKRSwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2004 13:52:53 -0500
Received: from localhost (localhost [127.0.0.1])
	by boreas.iversen-net.dk (Postfix) with ESMTP id C3EF975B38
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2004 19:52:51 +0100 (CET)
Received: from boreas.iversen-net.dk ([127.0.0.1])
	by localhost (boreas.iversen-net.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 16745-09 for <linux-scsi@vger.kernel.org>;
	Thu, 18 Nov 2004 19:52:47 +0100 (CET)
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2004 19:52:47 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I have a bug to report. I previously wrote (on linux-usb-devel) about p=
roblems=20
with http://bugme.osdl.org/show_bug.cgi?id=3D3728, which has now been f=
ixed.=20
However, the world is not trouble-free yet, as linux still crashes in c=
ertain=20
situations on 2.6.10-rc2 with SMP systems. (UP systems are fine).

The new bug is http://bugme.osdl.org/show_bug.cgi?id=3D3761, which I ma=
rked as=20
"blocking" because it's very easy to bring the whole system down.

Could someone smart please take a look at the dmesg I attached=20
to the bug post? Particularly, what the foo is going on here: ?

usb 4-2: USB disconnect, address 2
usb 4-2.3: USB disconnect, address 5
=A0target5:0:0: Illegal state transition <NULL>->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717
=A0[<b0324d16>] scsi_device_set_state+0xc6/0x130
=A0[<b031fcaa>] scsi_device_cancel+0x2a/0x106
=A0[<b031fe10>] scsi_device_cancel_cb+0x0/0x20
=A0[<b02f128e>] device_for_each_child+0x3e/0x70
=A0[<b031fe61>] scsi_host_cancel+0x31/0xc0
=A0[<b031fe10>] scsi_device_cancel_cb+0x0/0x20
=A0[<b026765e>] kobject_put+0x1e/0x30
=A0[<b026765e>] kobject_put+0x1e/0x30
=A0[<b0267630>] kobject_release+0x0/0x10
=A0[<b032726d>] scsi_remove_device+0x7d/0xb0
=A0[<b032641d>] scsi_forget_host+0x3d/0x60
=A0[<b031ff13>] scsi_remove_host+0x23/0x80
=A0[<b0378aa6>] storage_disconnect+0x86/0x9e
=A0[<b035cdb8>] usb_unbind_interface+0x88/0x90
=A0[<b02f21ef>] device_release_driver+0x7f/0x90
=A0[<b02f2435>] bus_remove_device+0x65/0xb0
=A0[<b02f11cf>] device_del+0x5f/0xb0
=A0[<b0364006>] usb_disable_device+0xb6/0x100
=A0[<b035f25f>] usb_disconnect+0x9f/0x150
=A0[<b035f2db>] usb_disconnect+0x11b/0x150
=A0[<b036053a>] hub_port_connect_change+0x3ba/0x3f0
=A0[<b035df38>] clear_port_feature+0x58/0x60
=A0[<b03607bc>] hub_events+0x24c/0x370
=A0[<b0360915>] hub_thread+0x35/0x110
=A0[<b01325c0>] autoremove_wake_function+0x0/0x60
=A0[<b01030b2>] ret_from_fork+0x6/0x14
=A0[<b01325c0>] autoremove_wake_function+0x0/0x60
=A0[<b03608e0>] hub_thread+0x0/0x110
=A0[<b01012d1>] kernel_thread_helper+0x5/0x14

I hope somebody can help me, and I apologize if I seem impatient. I rea=
lly=20
would like this issue to be resolved, not just for my own sake.=20

I'd be more than happy to help in any way I can, just say what you need=
, and=20
I'll get it. More debug info? Other kinds of log? Hardware information?

--=20
Regards,
Christian Iversen
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
