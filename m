From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: scsi timeout questions
Date: Mon, 23 Sep 2002 08:43:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020923154301.GA1359@beaverton.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E57A8B499@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e31.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g8NIalsH019116
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 14:36:47 -0400
Received: from dyn9-47-17-195 (dyn9-47-17-67.beaverton.ibm.com [9.47.17.67])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g8NIaks2053628
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 12:36:47 -0600
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57A8B499@EXA-ATLANTA.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

Mukker, Atul [atulm@lsil.com] wrote:
> new error handling?
> 
Unless I am looking at older versions of megaraid.[ch] in 2.4.20-pre5 this driver is
using the older error handler interfaces. The newer version of the error
handler (which is not that new anymore) is described at Eric Youngdale's
site http://www.andante.org/scsi_error.html. In 2.5 only the new version
of the error handler is supported.

-andmike
--
Michael Anderson
andmike@us.ibm.com

