From: "Mohit Katiyar" <katiyar.mohit@gmail.com>
Subject: iSCSI adapters
Date: Tue, 23 May 2006 17:34:36 +0900
Message-ID: <46465bb30605230134j58811b3bn53ebc8b534a2b0cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:27874 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S932113AbWEWIeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2006 04:34:37 -0400
Received: by nf-out-0910.google.com with SMTP id c31so578503nfb
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2006 01:34:36 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

Could anyone explain me the pattern of /sys/class/scsi_host/iscsi
deirectory structure? I have a question if i have two iSCSI host
adapter on a single system how will the entries in
/sys/class/scsi_host/iscsi  gets populated? Are there different
drectories for different host or some other pattern.

TIA
Mohit
