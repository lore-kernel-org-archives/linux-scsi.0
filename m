From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.1.7
Date: Mon, 10 May 2004 10:08:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084176508.409f387c1e110@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: nickyin@hotmail.com
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.1.7

Changelog for this release :

        * bugfixes from Andy <genanr@emsphone.com> :
                * read the last line of the config file
                * add an entry for the 3PARData storage ctlrs
                * read the last char of vendor and model strings
        * dmadm exits cleanly when it has nothing to do

Downloads and docs at http://christophe.varoqui.free.fr

[Nick, you were certainly hit by the bugs Andy spotted.
Please try this release.]

regards,
cvaroqui
-- 
