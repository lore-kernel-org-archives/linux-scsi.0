From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: scsi Target card and scsi Initiator card
Date: Thu, 07 Oct 2004 11:38:00 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4164F258.9090508@vlnb.net>
References: <017e01c4ab91$510a3e90$1610a8c0@spsoft.com> <4163DDC6.3030102@vlnb.net> <017901c4ac30$cde21510$1610a8c0@spsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.rol.ru ([194.67.21.9]:16072 "EHLO smtp.rol.ru")
	by vger.kernel.org with ESMTP id S267323AbUJGHhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 03:37:53 -0400
Received: from asplinux.ru ([195.133.213.194]:12795 "EHLO vlnb.net" smtp-auth:
	"vlnb@online.ru" TLS-CIPHER: "DHE-RSA-AES256-SHA keybits 256/256 version
	TLSv1/SSLv3" TLS-PEER-CN1: <none>) by gnome08.net.rol.ru with ESMTP
	id S4255130AbUJGHhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 11:37:51 +0400
In-Reply-To: <017901c4ac30$cde21510$1610a8c0@spsoft.com>
List-Id: linux-scsi@vger.kernel.org
To: Nikhil Dharashivkar <dharashivkar.nikhil@spsoftindia.com>
Cc: linux-scsi@vger.kernel.org

Nikhil Dharashivkar wrote:
> Hi,
>      Actually our setup of hardware is : There is one board . On that we
> have one target mode card (LSI) and more than one initiator cards.
>        First thing I have to do is I should able to export all LUNS or
> target devices connected to initiator card through this target mode card.
>       For that how should i think to develop software layer . Is there
> already implemeted code ?

Take a look on SCSI target mid-level (SCST) on 
http://scst.sourceforge.net. You just need to develop small target 
add-on to the LSI's initiator driver as it was done for Qlogic cards.

Vlad
