From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: qlogic 2312 problems on 2.6.16.22, 2.6.18rc4
Date: Thu, 17 Aug 2006 11:15:35 +0200
Message-ID: <200608171115.35522.arekm@pld-linux.org>
References: <200608140946.50411.arekm@pld-linux.org> <20060816181445.GU3674@andrew-vasquezs-computer.local> <200608162310.26541.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outgoing3.smtp.agnat.pl ([193.239.44.85]:18854 "EHLO
	outgoing3.smtp.agnat.pl") by vger.kernel.org with ESMTP
	id S932367AbWHQJPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2006 05:15:43 -0400
In-Reply-To: <200608162310.26541.arekm@pld-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wednesday 16 August 2006 23:10, Arkadiusz Miskiewicz wrote:

> Tyan manual ftp://ftp.tyan.com/manuals/m_s2891_100.pdf says on page 4
> ,,One PCI-X 100MHz slot (PCI-X B)''.
>
> Hm, while looking at that manual I see that on page 13 it says ,,one =
pci-x
> 100MHz device''. Maybe that's the problem since I didn't remove Adapt=
ec
> TARO controller. I should be able to get this tested again without ad=
aptec
> sooner than several weeks. Maybe I misunderstand what documentation s=
ays
> here.

The problem is solved now. Removing Adaptec controller from TARO slot m=
akes=20
system happy and there is no problem with qlogic card after that.

Weird mainboard. There should be warning with big letters on it ...=20

Thanks for help!
--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
