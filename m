From: Avinash Gowda <Avinash@UltraBac.com>
Subject: request sense and log sense in st driver
Date: Sat, 7 Sep 2002 21:01:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6DD0D32DC28A874A868FDA9E1C41B0DC564305@scooby.ultrabac.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hi:  I had a question on request sense and log sense in the st driver. I am trying to obtain the sense data (request and log sense) data for a scsi tape driver. These two operations are __NOT__ part of the header file mtio.h. and neither is it a part of st (driver). I would greatly appreciate if I can get some pointers on this. 

TIA. 

avinash
