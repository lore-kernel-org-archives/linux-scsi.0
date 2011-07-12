From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: pm8001 performance degradation?
Date: Tue, 12 Jul 2011 09:27:13 +0800
Message-ID: <316E3E573B654596BA694678AE395999@usish.com.cn>
References: <CAHQAjVFuvh72uJ4x9g-P0XrihfWfUt1YtipTJgd9iXzTS+Vz=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:46901 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab1GLB1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2011 21:27:19 -0400
In-Reply-To: <CAHQAjVFuvh72uJ4x9g-P0XrihfWfUt1YtipTJgd9iXzTS+Vz=w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'ersatz splatt' <ersatzsplatt@gmail.com>, lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org

> Hello Jack Wang and Lindar Liu,
> 
> 
> I am running the pm8001 driver (on applicable hardware including a
> several core SMP server).
> 
> When I run on an older kernel -- e.g. 2.6.34.7 -- I get about 73Kiops
> via an fio test.
> 
> When I run a current kernel -- e.g. 2.6.39.2 -- on the same system and
> same storage I get about 15Kiops running the same fio test.
> 
> Perhaps something has changes in the kernel that is not being accounted
for?
> Are you two still maintaining this driver?
> 
> 
> Regards,
> David
[Jack Wang]  Could you give your detailed topology, I will later try to
investigate the performance issue, but as I remember an Intel developer
reports in mailist some changes in block layer lead to JBOD performance
degradation. 

