From: Andries.Brouwer@cwi.nl
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Thu, 6 Mar 2003 07:39:18 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200303060639.h266dIo22884.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, torvalds@transmeta.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> See if this fixes it..

No, I am afraid not. My infinite loop does not pass through
scsi_eh_ready_devs().

Andries
