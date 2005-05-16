From: Christoph Hellwig <hch@infradead.org>
Subject: [gregoire.favre@gmail.com: What breaks aic7xxx in post 2.6.12-rc2 ?]
Date: Mon, 16 May 2005 16:26:07 +0100
Message-ID: <20050516152607.GA27989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53679 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261709AbVEPP0O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 11:26:14 -0400
Received: from hch by pentafluge.infradead.org with local (Exim 4.43 #1 (Red Hat Linux))
	id 1DXhTr-0007JS-Om
	for linux-scsi@vger.kernel.org; Mon, 16 May 2005 16:26:07 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

----- Forwarded message from Gr?goire Favre <gregoire.favre@gmail.com> -----

Date:	Mon, 16 May 2005 10:58:32 +0200
From:	Gr?goire Favre <gregoire.favre@gmail.com>
Subject: What breaks aic7xxx in post 2.6.12-rc2 ?
To:	linux-kernel@vger.kernel.org

Hello,

as I reported in
http://marc.theaimsgroup.com/?l=linux-kernel&m=111554477416794&w=2

I have lots of problem with aic7xxx (and till 2.6.12-rc2 everything
works perfectly). I have tried to compil 2.6.12-rc4-mm1 without probe
all Lun and it don't change anything at all to this problem.

I have two different controllers :

0000:00:05.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
0000:00:0a.0 SCSI storage controller: Adaptec AHA-2940U/UW/D / AIC-7881U

And I also use libsata.

Anyone got an idea on what's going wrong ?

Please CC to me : I am not on this mailinglist.
-- 
	Gr?goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----
