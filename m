From: "christophe.varoqui" <christophe.varoqui@free.fr>
Subject: Re: Removing the qlogicfc driver
Date: Sun, 18 Jan 2004 22:14:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401182214.45510.christophe.varoqui@free.fr>
References: <B179AE41C1147041AA1121F44614F0B0598E38@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.wanadoo.fr ([193.252.22.30]:45020 "EHLO
	mwinf0102.wanadoo.fr") by vger.kernel.org with ESMTP
	id S263823AbUARVPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 16:15:52 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E38@AVEXCH02.qlogic.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

2 independant switches,
each HBA connected to a different switch.

Here are the required info on one of them (QLA2200 in port 3) :

swtest20:admin> switchshow
switchName:     swtest20
switchType:     16.2
switchState:    Online
switchMode:     Native
switchRole:     Principal
switchDomain:   20
switchId:       fffc14
switchWwn:      10:00:00:60:69:c0:4e:51
switchBeacon:   OFF
Zoning:         OFF
port  0: id N1 In_Sync        Disabled
port  1: id N2 Online         F-Port 50:00:1f:e1:50:00:ae:19
port  2: id N1 Online         F-Port 10:00:00:00:c9:2a:35:26
port  3: id N1 Online         F-Port 21:00:00:e0:8b:03:8a:6a
port  4: id N2 Online         F-Port 10:00:00:00:c9:33:4d:60
port  5: id N2 Online         F-Port 50:00:1f:e1:50:00:ae:1c
port  6: id N1 Online         F-Port 10:00:00:00:c9:25:97:5e
port  7: -- N2 No_Module

swtest20:admin> nsshow
{
 Type Pid    COS     PortName                NodeName                 TTL(sec)
 N    141100;      3;50:00:1f:e1:50:00:ae:19;50:00:1f:e1:50:00:ae:10; na
    FC4s: FCP
    PortSymb: [39] "HSV110 (C)COMPAQ - EVA_TEST - ENT-V2005"
    Fabric Port Name: 20:01:00:60:69:c0:4e:51
 N    141200;    2,3;10:00:00:00:c9:2a:35:26;20:00:00:00:c9:2a:35:26; na
    FC4s: FCIP FCP
    Fabric Port Name: 20:02:00:60:69:c0:4e:51
 N    141300;      3;21:00:00:e0:8b:03:8a:6a;20:00:00:e0:8b:03:8a:6a; na
    Fabric Port Name: 20:03:00:60:69:c0:4e:51
 N    141400;    2,3;10:00:00:00:c9:33:4d:60;20:00:00:00:c9:33:4d:60; na
    FC4s: FCP
    PortSymb: [49] "UNIX (emx0) FCA-2354 S/W Rev 2.07: F/W Rev 3.81a4"
    Fabric Port Name: 20:04:00:60:69:c0:4e:51
 N    141500;      3;50:00:1f:e1:50:00:ae:1c;50:00:1f:e1:50:00:ae:10; na
    FC4s: FCP
    PortSymb: [39] "HSV110 (C)COMPAQ - EVA_TEST - ENT-V2005"
    Fabric Port Name: 20:05:00:60:69:c0:4e:51
 N    141600;    2,3;10:00:00:00:c9:25:97:5e;20:00:00:00:c9:25:97:5e; na
    NodeSymb: [35] "Emulex LP8000 FV3.81A1  DV5-4.81A9 "
    Fabric Port Name: 20:06:00:60:69:c0:4e:51

The Local Name Server has 6 entries }

swtest20:admin> nsallshow
{
  141100 141200 141300 141400 141500 141600
6 Nx_Ports in the Fabric }


regards,
cvaroqui
