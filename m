From: piotr@larroy.com (Pedro Larroy)
Subject: Re: [BUG] 2.6.9-rc2 scsi and elevator oops when I/O error
Date: Mon, 11 Oct 2004 17:24:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041011152414.GA5118@larroy.com>
References: <20041011050320.GA28703@larroy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from FW-30-241.go.retevision.es ([62.174.241.30]:56485 "EHLO
	mayhem.ghetto") by vger.kernel.org with ESMTP id S269048AbUJKPYR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 11:24:17 -0400
Content-Disposition: inline
In-Reply-To: <20041011050320.GA28703@larroy.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

Another side problem I have observed about this:
=09
Processes that call sync() get stuck into D state, for example shutdown=
=2E


--=20
Pedro Larroy Tovar | Linux & Network consultant |  pedro%larroy.com=20

Las patentes de programaci=F3n son nocivas para la innovaci=F3n
	http://proinnova.hispalinux.es/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
