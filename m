From: "Subodh S" <subodh_s_1975@mail.com>
Subject: Executing Scsi Inquiry under different conditions
Date: Sun, 09 Mar 2003 05:16:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030309101640.50897.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

If for some reason a lun not available ... what should be the output of the inquiry command ?? Assuming that the following happens when the host machine is up..

1. The LUN has been removed temporarily using the lun management software 
2. The physical device that constitutes the lun stops responding

I though both the above situations would produce the same output. But, the inquiry command behaves differently under the above conditions.

For the first scenario the command works properly and shows an output. For the second it displays an error.

Can someone help me understand this difference in behaviour ??

Thanks and Regards,
Subodh
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

