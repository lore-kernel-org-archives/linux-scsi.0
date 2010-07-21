From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: drivers/scsi/arm/acornsci.c -- Dead CONFIG_* options
Date: Wed, 21 Jul 2010 15:52:29 +0200
Message-ID: <86d3uhhrhe.fsf@peer.zerties.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

Hi all!
      =20
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

I also encountered some reference problems in
drivers/scsi/arm/acornscsi.c. But they seem to be intentionally, in
order to make integration into the linux kernel working. But the last
changelog entry is from 1998. So perhaps some of this ifdefs can be
removed. If this should be done i can make up a patch and send it.

[0] http://vamos1.informatik.uni-erlangen.de
--=20
(=CE=BB x . x x) (=CE=BB x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
