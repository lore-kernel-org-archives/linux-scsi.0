From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Help - looking for IO test tools
Date: Wed, 4 Aug 2004 21:05:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804190525.GB678@inara.maison.net>
References: <519672568F040C41B6FAC21ADF51B18F1C4441@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-1.free.fr ([213.228.0.44]:29362 "EHLO
	postfix3-1.free.fr") by vger.kernel.org with ESMTP id S266781AbUHDTE7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 15:04:59 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18F1C4441@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

* Lee Xing (lxing@crossroads.com) [20040804 13:58]:

> Just wondering if there are any IO test tools like IOMeter, with
> which we can select different parameters (IO size, percentage of
> read/write, percentage of sequential/random, etc.) and see the
> IO rate (MB/sec) and num of IO/sec with the selected parameters.

Check out iozone v3.
http://www.iozone.org/

HTH,
Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern.c=
h
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
