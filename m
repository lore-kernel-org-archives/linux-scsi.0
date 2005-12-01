From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: How to setup git
Date: Thu, 1 Dec 2005 09:28:12 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662C65@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27813 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932243AbVLAO2Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 09:28:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,

I'm trying to use git and in the middle of installing it on the RHEL4 U2.
I have following modules in hand.
- git-core-0.99.7-1.i386.rpm
- cogito-0.15.1-1.noarch.rpm

During 'git-core-0.99.7-1.i386.rpm' installation, I'm getting following
error message,
[root@dhcp root]# rpm-ihv git-core-0.99.7-1.i386.rpm
error: Failed dependencies:
	perl(String::ShellQuote) is needed by git-core-0.99.7-1.i386
	python >= 2.4 is needed by git-core-0.99.7-1.i386

Where can I find those modules?
Also, please point out if you see any further obstacles along the way to
move forward.

Any feedback would be appreciated.

Regards,

Seokmann
