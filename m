From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: memcpy_toio/memcpy_fromio 64 bit safe?
Date: Wed, 16 Mar 2005 21:43:00 +0100
Message-ID: <1111005781.6292.61.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458BED2493@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:36312 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261302AbVCPUnG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:43:06 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BED2493@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Wed, 2005-03-16 at 15:19 -0500, Salyzyn, Mark wrote:
> Unsigned long is less than pointer, the reference passed in to the 'dst'
> variable.


that's on that other OS, not this one ;)

