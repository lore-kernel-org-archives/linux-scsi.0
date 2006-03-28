From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Tue, 28 Mar 2006 09:37:47 +0200
Message-ID: <4428E7CB.6030407@s5r6.in-berlin.de>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>	 <Pine.LNX.4.64.0603261424590.15714@g5.osdl.org>	 <4427FEC9.4010803@torque.net>	 <Pine.LNX.4.64.0603270854570.15714@g5.osdl.org>	 <20060327172530.GH3486@parisc-linux.org>	 <Pine.LNX.4.64.0603270936290.15714@g5.osdl.org> <1143489287.4970.76.camel@localhost.localdomain> <44285929.4020806@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:7406 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S932250AbWC1Hig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 02:38:36 -0500
In-Reply-To: <44285929.4020806@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@osdl.org>, Matthew Wilcox <matthew@wil.cx>, Bodo Eggert <7eggert@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> Alan Cox wrote:
[host/ channel/ target/ LU enumeration...]
>> is still a very visible reality if you work in a data centre or with
>> server kit, or if you have tape arrays or multi-CD towers. The LUN or
>> device number in particular are generally the number emblazoned on each
>> slot in the unit
...
> USB multi-card readers seem to like the concept of LUNs as well.

Sure. The h:c:i:l tuple does not provide the LUN though, only an ersatz.
-- 
Stefan Richter
-=====-=-==- --== ===--
http://arcgraph.de/sr/
