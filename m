From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: U160 on sym53c8xx very slow
Date: Mon, 20 Oct 2003 09:48:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03Oct20.094816edt.332465@cyborg.cybernetics.com>
References: <pan.2003.10.20.13.02.47.426779@mandrakesoft.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:41226 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262569AbTJTNsX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 09:48:23 -0400
In-Reply-To: <pan.2003.10.20.13.02.47.426779@mandrakesoft.com>
List-Id: linux-scsi@vger.kernel.org
To: 'nico' <nico@mandrakesoft.com>, linux-scsi@vger.kernel.org

> sym0: Symbios NVRAM, ID 7, Fast-80, SE, parity checking

SE == Single-ended

You are using a single-ended terminator, which limits the SCSI bus to 40
MB/s bandwidth.  Try a LVD terminator which should give you the full 160
MB/s.  But remember that this only increases the speed at which data can
burst over the SCSI bus, not the speed at which the disk can access the
media.

Anthony J. Battersby
Cybernetics

