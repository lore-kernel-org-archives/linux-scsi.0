From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Wed, 3 Mar 2010 10:45:49 GMT
Message-ID: <201003031045.o23Ajnjr020110@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48852 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0CCKpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 05:45:50 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o23AjnUL020111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 3 Mar 2010 10:45:50 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #34 from Bernd Zeimetz <bzed@debian.org>  2010-03-03 10:45:41 ---
bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11646
> 
> 
> 
> 
> 
> --- Comment #33 from Csillag Tamas <cstamas@digitus.itk.ppke.hu>  2010-03-03 09:59:55 ---
> Dear Bernd Zeimetz,
> 
> Can you tell us what version your qlogic bios is?

The QLogic Bios was upgraded a few days ago to the latest versionfrom QLogic,
without any changes in the behaviour.

--------------------------------------------------------------------------------
HBA Instance 0: QLA2460 Port 1
--------------------------------------------------------------------------------
Product Identifier               : DS4000 FC 4Gb PCI-X Single Port HBA
Misc. Information                : PW=15W;PCI=66MHZ;PCI-X=266MHz
EFI Driver Version               : 2.04
Firmware Version                 : 4.06.02
BIOS Version                     : 2.10
FCode Version                    : 2.04

--------------------------------------------------------------------------------
HBA Instance 1: QLA2460 Port 1
--------------------------------------------------------------------------------
Product Identifier               : DS4000 FC 4Gb PCI-X Single Port HBA
Misc. Information                : PW=15W;PCI=66MHZ;PCI-X=266MHz
EFI Driver Version               : 2.04
Firmware Version                 : 4.06.02
BIOS Version                     : 2.10
FCode Version                    : 2.04

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
