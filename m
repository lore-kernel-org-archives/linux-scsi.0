From: "Subodh S" <subodh_s_1975@mail.com>
Subject: How to change retry count of lower layer drivers
Date: Tue, 15 Apr 2003 09:07:12 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030415140713.38173.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Whenever the path on which an I/O is in-progress, 
goes down, sd takes a long time to detect it. As per 
my knowledge it would be 60sec * 5(no. of retries) 
plus the time taken by the lower layer driver(hba) 
to detect the failure. Is this correct ?? Is there a 
way available to reduce this "timeout/retry count" 
value without modifying sd.c

-subodh



-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
