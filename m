From: ersatz splatt <ersatzsplatt@gmail.com>
Subject: pm8001 performance degradation?
Date: Mon, 11 Jul 2011 12:06:15 -0700
Message-ID: <CAHQAjVFuvh72uJ4x9g-P0XrihfWfUt1YtipTJgd9iXzTS+Vz=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40858 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1GKTGQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2011 15:06:16 -0400
Received: by wyg8 with SMTP id 8so2795560wyg.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2011 12:06:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com, lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org

Hello Jack Wang and Lindar Liu,


I am running the pm8001 driver (on applicable hardware including a
several core SMP server).

When I run on an older kernel -- e.g. 2.6.34.7 -- I get about 73Kiops
via an fio test.

When I run a current kernel -- e.g. 2.6.39.2 -- on the same system and
same storage I get about 15Kiops running the same fio test.

Perhaps something has changes in the kernel that is not being accounted for?
Are you two still maintaining this driver?


Regards,
David
