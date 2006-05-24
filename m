From: "C'est Pierre" <cestpierre@gmail.com>
Subject: fdisk weirdness.
Date: Wed, 24 May 2006 21:56:25 +0100
Message-ID: <5485940d0605241356j1128e38aq1049a9686265547f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:48684 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S932407AbWEXU40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2006 16:56:26 -0400
Received: by py-out-1112.google.com with SMTP id z59so2295495pyg
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2006 13:56:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, suse-sles-e@suse.com

Greetings,

I've been trying to setup a server for a cluster that is attached to a
fibre channel storage (an HP EVA 3000 hsv100). Prior to allocating a
vdisk on the storage for this server, whenever I'd issue "fdisk -l",
it wouldn't print anything at all. After correctly alocating the disk
on the Storage, it shown 2 disks, sda and sdb. At this point, I assume
they're 2 LUNS for the same vdisk, being that the Storage attached
through two different FC cards for redundancy/failover - feel free to
correct me if I am wrong. However, the /dev/cciss/c0d0[pN] (compaq
smartarray or something) doesn't show up on it's output.

Any hints?

Thank you,
Pierre
