From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] [PATCH RFC] replace dm hw handlers with scsi
	handlers
Date: Tue, 17 Oct 2006 10:37:05 +0200
Message-ID: <1161074225.6464.1.camel@localhost.localdomain>
References: <1160684310.4163.4.camel@madmax>  <4530E19A.8040002@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:54944 "EHLO smtp2-g19.free.fr")
	by vger.kernel.org with ESMTP id S1423168AbWJQIhK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 04:37:10 -0400
In-Reply-To: <4530E19A.8040002@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

Le samedi 14 octobre 2006 =C3=A0 09:09 -0400, Mike Christie a =C3=A9cri=
t :
> Christophe V, I was wondering what is the vendor/module info for your
> box? We have a MSA1000 VOLUME/COMPAQ here, but START_STOP does not
> work.
> I mean if I send the command it always executes successfully, but the
> device does not failover (READ/WRITEs fail). I tried just running
> sg_start and this runs ok but READ/WRITE still fail, so I hacked up
> scsi_debug to simulate my testing.=20

It was a HSG80 based array, namely a HP EMA8000.
I do not have access to this hardware anymore.

Regards,
cvaroqui

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
