From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [dm-devel] Re: fibre channel/multipath questions
Date: Tue, 30 Aug 2005 11:26:12 +0200
Message-ID: <1125393973.3224.16.camel@laptopd505.fenrus.org>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
	 <20050829172316.GC7875@infradead.org> <1125378108.6375.15.camel@zezette>
	 <200508301119.24072.Rik.Bobbaers@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7912 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751300AbVH3J0W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 05:26:22 -0400
In-Reply-To: <200508301119.24072.Rik.Bobbaers@cc.kuleuven.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>
Cc: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>


> the last rule poses the problem. depending on how many multipath devices i 
> have, i constantly have to change lilo.conf for every machine.
> 
> in bsd, there is a way to set your drives to a fixed name, is there something 
> alike in linux? or a sollution to this problem? (i'm definately willing to 
> help find one, if there isn't... and i guess i'm not the only one with this 
> problem?)

there is mount-by-label (filesystem label that is) that at least Fedora
and RHEL distros use, and I assume many other distros support too even
if they don't use it by default.


