From: "Florian G. Pflug" <fgp@phlo.org>
Subject: Which Version of the aacraid driver shall I use?
Date: Mon, 20 Dec 2004 18:48:23 +0100
Message-ID: <41C71067.6000209@phlo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rivendell.solution-x.com ([213.147.174.20]:51386 "EHLO
	rivendell.solution-x.com") by vger.kernel.org with ESMTP
	id S261585AbULTRpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 12:45:16 -0500
Received: from v213-187.vps.tuwien.ac.at (HELO [10.100.7.48]) (fgp@[128.131.213.187])
          (envelope-sender <fgp@phlo.org>)
          by rivendell.solution-x.com (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-scsi@vger.kernel.org>; 20 Dec 2004 17:53:07 -0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I have a few questions regarding the aacraid driver. Sorry if this is 
explained in some FAQ somewhere - I googled for an hour or so, and did't 
find the information I need.

.) Which Version of the aacraid driver is recommended for a production 
system? I'm running a (vanilla) linux 2.6.9 kernel, and am wondering if 
I should go with the included aacraid driver, or use the aacraid 1.1.5 
driver available on www.adaptec.com? My controller is an Adaptec 2200S.

.) How does one upgrade the firmware, if there is no windows 
installation on the machine? (The archive with firmware version 7349 
contains 4 .ufi files, and an afu.exe - probably AdapctedFlashUtility, 
or something :-( ).

.) There seems to be a cli app for configuring aacraid controllers 
called afacli, but I can't find a way to download it anywhere? Does 
anyone have a link to either source or binary of this program?

greetings, Florian Pflug

PS: Please reply to me directly, as I am not on this list.
