From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: kernel addresses
Date: 29 Oct 2002 09:46:20 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035884780.5852.9.camel@irongate.swansea.linux.org.uk>
References: <20021029010744.83318.qmail@web80301.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021029010744.83318.qmail@web80301.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

For the 2.4 case you will always get kernel addresses. Bounce buffer
handling will depend where the page being referenced lives and if its
directly kernel accessible. In the 2.5 case it depends on your pci
device mask

