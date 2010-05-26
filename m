From: Erwan Velu <erwanaliasr1@gmail.com>
Subject: Question about the maximum value for unload_head
Date: Wed, 26 May 2010 22:32:33 +0200
Message-ID: <4BFD8561.2060706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56250 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0EZUch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2010 16:32:37 -0400
Received: by wwb13 with SMTP id 13so709467wwb.19
        for <linux-scsi@vger.kernel.org>; Wed, 26 May 2010 13:32:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey folks,

I'm in an industrial situation where my Linux system could be strongly
shacked for some minutes.
I'm able to detect this situation and so, to protect my hard drive, I
park its heads by using the unload_heads feature.
I have nothing to say more than it works sooooo good ! But I saw there
is a limitation to 30sec as #define MAX_PARK_TIMEOUT 30000

That mean in my case that I have to manage a stupid script that have to
retrigger the unload_heads every 30sec. That's stupid script and I
wonder if it could be possible to get rid of it. Why is there such
limitation. Why 30sec ?

Could it be possible to increase this value ?

Thanks for your inputs,
Erwan Velu
