From: "NucleoDyne Systems, " "Inc." <nucleon@nucleodyne.com>
Subject: [Fwd: lost SCSI IO]
Date: 08 Dec 2003 13:22:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070918551.3728.0.camel@driver>
Reply-To: nucleon@nucleodyne.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FBl2ApORzlObPLBzxBcE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([216.148.227.85]:19683 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S261569AbTLHVWn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2003 16:22:43 -0500
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>


--=-FBl2ApORzlObPLBzxBcE
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


-- 
--
NucleoDyne Corporation
nucleon@nucleodyne.com
www.nucleodyne.com

--=-FBl2ApORzlObPLBzxBcE
Content-Disposition: inline
Content-Description: Forwarded message - lost SCSI IO
Content-Type: message/rfc822

Received: from easyspace.ezspl.net ([216.74.109.141]) by
	sccrmxc14.comcast.net (sccrmxc14) with ESMTP id
	<20031208193929s14001kj47e>; Mon, 8 Dec 2003 19:39:29 +0000
X-Originating-IP: [216.74.109.141]
Received: from [67.72.78.212] (helo=vger.kernel.org) by easyspace.ezspl.net
	with esmtp (Exim 4.24) id 1ATRE9-00006R-BX for nucleon@nucleodyne.com; Mon,
	08 Dec 2003 14:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand id
	S261575AbTLHTcy (ORCPT <rfc822;nucleon@nucleodyne.com>); Mon, 8 Dec 2003
	14:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261660AbTLHTcy
	(ORCPT <rfc822;linux-kernel-outgoing>); Mon, 8 Dec 2003 14:32:54 -0500
Received: from sccrmhc13.comcast.net ([204.127.202.64]:24471 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP id S261575AbTLHTcv
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>); Mon, 8 Dec 2003 14:32:51
	-0500
Received: from nucleodyne.com (unknown[12.24.46.66]) by comcast.net
	(sccrmhc13) with SMTP id <20031208193250016007eq7me> (Authid: nucleodyne);
	Mon, 8 Dec 2003 19:32:50 +0000
Message-ID: <3FD4D103.2080007@nucleodyne.com>
Date: Mon, 08 Dec 2003 11:29:07 -0800
From: "NucleoDyne Systems Inc." <nucleon@nucleodyne.com>
Organization: www.NucleoDyne.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.0.0)
	Gecko/20020623 Debian/1.0.0-0.woody.1
X-Accept-Language: en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: lost SCSI IO
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
X-AntiAbuse: This header was added to track abuse, please include it with
	any abuse report
X-AntiAbuse: Primary Hostname - easyspace.ezspl.net
X-AntiAbuse: Original Domain - nucleodyne.com
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - vger.kernel.org
Content-Transfer-Encoding: 7bit

I have been developing a SCSI based application and facing hardship due 
to lack of  better debugging support in SCSI domain on linux. May be I 
am not very familiar with linux scsi subsystem.

 I have a lost IO, sitting somewhere in some queue. The scsi logging 
facility has been turned on with : echo "scsi log all" > /proc/scsi/scsi.

The syslog shows that the request has started:
scsi_do_req (host = 0, channel = 0 target = 3, buffer =00000000, bufflen 
= 0, d)command : 00  20  00  00  00  00
Leaving scsi_do_req()

The SCSI bus trace does not show any activity.

I guess only way to find out the state of the IO is to put printf and 
recompile the kernel. HP-UX had facilities like  lkcd, linux crash dump 
analyzer. I used to be called q4. A perl script could be written to 
navigate kernel data structures and extract information from them on a 
running system. If we had that kind of tool already into linux then 
debugging the live system would be easier.

Is there a plan to include lkcd into  default kernel?



-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--=-FBl2ApORzlObPLBzxBcE--

