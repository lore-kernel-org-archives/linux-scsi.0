From: gaoqiang <gaoqiangscut@gmail.com>
Subject: question about  path_id of scsi hard disk
Date: Fri, 20 Jul 2012 16:24:34 +0800
Message-ID: <op.whqka8y2n27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60941 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2GTIYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2012 04:24:46 -0400
Received: by wibhm11 with SMTP id hm11so262868wib.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jul 2012 01:24:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm using udev to manage my hard disks. but I'm confusing
about the "PATH_ID"

gaoqiang@h150:~$/lib/udev/path_id  /block/sda
ID_PATH=3Dpci-0000:01:00.0-scsi-0:0:0:0

the path_id is about disk or about disk slot ?

many thanks.


--=20
=CA=B9=D3=C3 Opera =B8=EF=C3=FC=D0=D4=B5=C4=B5=E7=D7=D3=D3=CA=BC=FE=BF=CD=
=BB=A7=B3=CC=D0=F2: http://www.opera.com/mail/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
