From: Willem Riede <wrlk@riede.org>
Subject: Re: 2.6.0-test3: scsi: Saw underflow (231 of 255 bytes). Treated as error
Date: Wed, 20 Aug 2003 21:02:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821010237.GA19306@linnie.riede.org>
References: <Pine.GSO.4.55.0308201346170.6320@stekt37>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:28073 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262346AbTHUBCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2003 21:02:03 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.55.0308201346170.6320@stekt37>; from tuukkat@ee.oulu.fi on Wed, Aug 20, 2003 at 06:58:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.08.20 06:58, Tuukka Toivonen wrote:
> I'm running 2.6.0-test3 and get these messages during bootup:
> 
> (scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
> (scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
> (scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
> (scsi0:A:0:0): Saw underflow (231 of 255 bytes). Treated as error
> (scsi0:A:0:0): CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
> 
> However, then it proceeds normally and the SCSI disk works fine.
> I also occasionally get similar error messages while using the disk
> heavily, however, everything seems to work fine.

I reported that problem as far back as 2.5.74-bk2, and I still have that
problem with 2.6.0-test3 also. Seems nobody cares :-(.

See http://marc.theaimsgroup.com/?l=linux-scsi&m=105740779106110&w=2

Willem Riede.
