From: Adrian Palmer <adrian.palmer@seagate.com>
Subject: [Announce] ZDM-Device-Mapper
Date: Tue, 22 Sep 2015 09:56:58 -0600
Message-ID: <CAKdFiL6BVaQcr7RHZFycKLfUSV+oLkvP9Abzy+y_3y14FwK-wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:16706 "EHLO
	mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932929AbbIVP5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 11:57:02 -0400
Received: from pps.filterd (m0075028.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8MFuMw5013176
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2015 11:56:59 -0400
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com [209.85.213.173])
	by mx0b-00003501.pphosted.com with ESMTP id 1x34239x1e-5
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2015 11:56:59 -0400
Received: by mail-ig0-f173.google.com with SMTP id x6so12134262igx.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2015 08:56:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Josh Bingaman <josh.bingaman@seagate.com>, Roger J Kassab <roger.j.kassab@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Paul Paulson <paul.paulson@seagate.com>

All;


Seagate is release the much requested device mapper shim for SMR.  In
response to requests at Linux Plumber's Conference, we've make it
available as soon as possible.

We've held off releasing it to ensure stability and to remove
frustration and reduce bring-up time to other developers who have
shown interest in exploring SMR solutions.

We encourage testing and collaboration to make this a great product
for the first generation of SMR drive support.

Please reply to me directly for questions.

location:
https://github.com/Seagate/ZDM-Device-Mapper



Adrian Palmer
Firmware Engineer II
R&D Firmware
Seagate, Longmont Colorado
720-684-1307
adrian.palmer@seagate.com
