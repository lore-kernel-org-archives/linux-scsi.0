From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: dmx3191d scsi driver needed
Date: Tue, 12 Oct 2004 17:59:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3oej8gc6x.fsf@merlin.emma.line.org>
References: <ckglad$lrl$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:52388 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S265971AbUJLP7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 11:59:05 -0400
In-Reply-To: <ckglad$lrl$1@sea.gmane.org> (news_jamrock@yahoo.com's message of
	"Tue, 12 Oct 2004 08:19:11 -0500")
List-Id: linux-scsi@vger.kernel.org
To: jamrock <news_jamrock@yahoo.com>
Cc: linux-scsi@vger.kernel.org

"jamrock" <news_jamrock@yahoo.com> writes:

> I need a driver for the dmx3191d SCSI card.  The card came with a Umax
> scanner.

Some of the el-cheapo 53c drivers used to work for the Domex
DTC31whatverE, but you'd probably be better off getting a real
chip. Tekram DC-390 are cheap, as are controllers based on a NCR or
Symbios 53C810A.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
