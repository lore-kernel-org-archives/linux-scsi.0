From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: adaptec 2120S software under RedHat 8.0 and FC2
Date: Wed, 16 Mar 2005 11:20:25 -0000 (GMT)
Message-ID: <1049.137.195.14.2.1110972025.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20050316112025_35256"
Received: from izanagi.macs.hw.ac.uk ([137.195.13.5]:65497 "EHLO
	izanagi.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S262550AbVCPLU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 06:20:26 -0500
Received: from surya.macs.hw.ac.uk ([137.195.13.8])
	by izanagi.macs.hw.ac.uk with esmtp (Exim 4.34)
	id 1DBWQr-0000vh-Ax
	for linux-scsi@vger.kernel.org; Wed, 16 Mar 2005 11:11:21 +0000
Received: from localhost ([127.0.0.1] helo=www.macs.hw.ac.uk)
	by surya.macs.hw.ac.uk with smtp (Exim 4.10)
	id 1DBWZd-0000qV-00
	for linux-scsi@vger.kernel.org; Wed, 16 Mar 2005 11:20:25 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

------=_20050316112025_35256
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Could someone possibly help?

I have upgraded a machine from RedHat 8.0 to FC2 and the
adaptec-browser1 and adaptec-smbe software that I installed is not working
properly. It looks ok at first glance but if I pull a disk out I only get
informed of the 'informational' type messages.
(Also the browser interface to the RAID doesn't notice that the disk has
been pulled)

These are the RPMs that I installed from adaptec:
  adaptec-browser-1.2b-2
  adaptec-smbe-1.01.005-0

and I am running this kernel: 2.6.8-1.521smp

Note the mail part works ok and I do get informational messages when I use
the browser interface and I tell it to rescan, (the array is rebuilt ok),
but after the disk is pulled, from the browser interface it still shows
the disk as being there, and it is only when I tell it to rescan that it
starts sending out the informational messages and rebuilds.
The messages are logged to /var/log/messages but it seems that anotifyd is
not picking them up.

Maybe I just need to upgrade the firmware and put on the latest RPMs?
I think I am at firmware revision 7244.

I have attached the anotify.conf file.

Thanks in advance,
Ross

-- 
Ross Macintyre (raz@macs.hw.ac.uk)
------=_20050316112025_35256
Content-Type: text/xml; name="anotify.conf"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="anotify.conf"

<?xml version="1.0" encoding="UTF-8"?>
    <tdoc xml:lang="en-US">
        <conf id="notification">
            <conf id="from">
                Adaptec SMBE Event Notifier
            </conf>
            <conf id="subject">
                Adaptec Hardware Event
            </conf>
            <conf id="users">
                <conf id="help@macs.hw.ac.uk">
                    <conf id="severity-level">
                        1 2 3
                    </conf>
                    <conf id="locale">
                        en-GB
                    </conf>
                    <conf id="notification-type">
                        email
                    </conf>
                </conf>
            </conf>
            <conf id="smtp">
                <conf id="server-name">
                    localhost
                </conf>
                <conf id="port-number">
                    25
                </conf>
            </conf>
            <conf id="sender">
                root@macs.hw.ac.uk
            </conf>
        </conf>
    </tdoc>
------=_20050316112025_35256--

