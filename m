Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1426A4582D6;
	Thu, 30 Jul 2026 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437401; cv=pass; b=F6omfOmsViG/neu52F8z9ltsTGqWfTvDo6WBN6rlXUAQ5FrYPycXP6z1KEPvCJcIBjiATf5mTzjh2BX+u3+1Oc7W+9tvG78oUezPv62hDgu49tfxyZ53e2Cc5ZqJeGYIPdsiv/0XyPo28fHvalrO8XkjuLizS6O9MeG7H+DjK0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437401; c=relaxed/simple;
	bh=j3MyigpeC5Ijpn5EEjNzQhxGWsp7n/nU7e0eLGY29rE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZC25Q63mMNndYgbvj9GuXfb3ykeytVwBPV7fLrnz9eye1FKWXf5F1Tj8DHUBbEpDsjJSnErjgGXOGIlex/+jn+P7XocmHoXFwHrNY7VwBpxXv+lvTcYfpOSRQbPkZJ40GxG1vrd3ID2gW332Gx3Bzt0ly9DIsMJcUTSt01sQUkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b=M11Ze4Z0; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=mhklkml@zohomail.com header.b="M11Ze4Z0"
ARC-Seal: i=1; a=rsa-sha256; t=1785437355; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RP+ZACf7Atd5jG69Yt6kJceo9yjRpuy9d/+ytXWuytcqaT9DBSD4BXgid7PJO2tc4/jNN82nbyH+3iPEk1akUqiJtcNrr5vQ1ig87lDfgFs/js6gQxF/V/vDMTJQnOLHhpY4UTQNK5j4MRbv7Mbi6L2pR2cVHzroQW30sy9PLxk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1785437355; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id; 
	bh=auiQFNA+k9JpHaZHr3bm9sEunjz93jxgRp64jfQ6/Kw=; 
	b=CG2H2Aze0VRpQX5E6saOOYio4zub41AhpDnlhvYrJIrOrBydtqC34sLm6zOWvguXIQavW800dVV8tJ8Ef9duElEOs9FXOw7tMIEH0Wppsv55BV6BYSAp930b1Jbc9HzcQ2RiQiE4pj5Cnpxgl2lSpslYNWQxQ377JgvY1k0dBuU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=mhklkml@zohomail.com;
	dmarc=pass header.from=<mhklkml@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1785437355;
	s=zm2022; d=zohomail.com; i=mhklkml@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:Reply-To:Reply-To:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=auiQFNA+k9JpHaZHr3bm9sEunjz93jxgRp64jfQ6/Kw=;
	b=M11Ze4Z0lJfQSB+D9C2s47K9EnTkuZD2jSAoVOIXozVyB0KqaaNUwc9SXhUWA8H2
	LHe8KrVlrZCYGhKRZf+uRaQ8JNcf5bv373nj2Y1r2j2OqS0C3cSQr8dodgEoRJiOvx+
	Q7w4h0Hg58x1WPmZWwE+ceD8f2alzxVWBuNV11nI=
Received: by mx.zohomail.com with SMTPS id 17854373524209.669229379695025;
	Thu, 30 Jul 2026 11:49:12 -0700 (PDT)
From: Michael Kelley <mhklkml@zohomail.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 0/6] Remove support for Windows Server 2012/2012R2 & Win8/Win8.1 versions of Hyper-V
Date: Thu, 30 Jul 2026 11:48:40 -0700
Message-Id: <20260730184846.3165-1-mhklkml@zohomail.com>
X-Mailer: git-send-email 2.25.1
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: zu080112277e7f3f3c3960a9a3ae522f0a0000772c396ba240301fb5efc9800e42fa31dc9213ac5df55f849f:ZohoMail
X-Zoho-CM-AccountID: 0c88436b239415d28725328898ceccb9ce2ba3b61598c1c37bcb2109e0248174
X-ZohoMailClient: External

From: Michael Kelley <mhklinux@outlook.com>

Linux code for running as a Hyper-V guest includes special cases for
running on Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions
were initially released 14 years ago, and official support ended in 2023
(unless a customer has contracted for extended security updates). Given
the release of subsequent versions with improved functionality, there's
no need to continue to support the latest Linux kernels on these versions
of Hyper-V. If someone is running Linux on one of these older Hyper-V
versions and doesn't want to upgrade, they can continue to do so as
presumably they don't want upgrade the Linux version either.

Simplify Linux code by removing special cases for running on these
old versions of Hyper-V. This includes removing the negotiation of the
VMBus protocol versions for WS2012/Win8, and the special case code based
on those VMBus protocol versions. Changes are in the core VMBus code and
several drivers for synthetic VMBus devices.

Some VMBus drivers have device-specific protocols with the Hyper-V host.
Further simplify the code by removing the use of protocol versions that
are specific to WS2012/Win8 and earlier.

Finally, the WS2012/Win8 versions of Hyper-V were the last to use
messages to deliver synthetic timer interrupts. Starting in WS2016/Win10,
stimer interrupts are delivered to their own assigned interrupt vector
(called "Direct Mode"). So remove the code for handling timer interrupts
delivered as messages. This removal has a broader benefit in removing
a key blocker to disentangling VMBus code (which handles the messages)
and stimer code, as they should be independent of each other. The
final disentangling will come as a follow-on patch set.

Testing:
* VM on local Hyper-V on up-to-date Windows 11
* Added temp debug code to suppress Direct Mode enumeration. Fallback
  to LAPIC timer worked as expected (x86/x64 only)
* Azure VM DC16eds v6: TDX CoCo VM with HvLite paravisor
* Azure VM DC16ads v6: SEV-SNP VM with an older paravisor
* Azure VM D16alds_v7: normal AMD x86 VM with HvLite paravisor
* Azure VM D16plds v6: normal ARM64 VM with MSFT Cobalt processor
* Not tested running in VTL2

There's no specific urgency to removing the special case code for
WS2012/Win8, so if the broader Linux kernel community surfaces
a reason why this clean-up should not be done now, we can wait.
But I think we want to eventually stop carrying around this extra
baggage, and based on discussions with the Hyper-V team within
Microsoft, we're past the point that it has any value.

Michael Kelley (6):
  Drivers: hv: Remove support for WS2012/2012R2 & Win8/8.1 version of
    Hyper-V
  hv_sock: Remove check for old Hyper-V hosts
  hv_netvsc: Remove GPADL teardown special case for old Hyper-V hosts
  drm_hyperv: Remove support for synth video protocol of old Hyper-V
    hosts
  scsi: storvsc: Remove support for storvsc protocol of old Hyper-V
    hosts
  clocksource: hyper-v: Remove support for stimer interrupts in message
    mode

 arch/x86/hyperv/hv_init.c                 |  17 +--
 arch/x86/kernel/cpu/mshyperv.c            |   4 +-
 drivers/clocksource/hyperv_timer.c        | 150 +++-------------------
 drivers/gpu/drm/hyperv/hyperv_drm_proto.c |  33 ++---
 drivers/hv/channel_mgmt.c                 |   4 -
 drivers/hv/connection.c                   |   8 +-
 drivers/hv/hv.c                           |   4 -
 drivers/hv/hv_balloon.c                   |  36 +++---
 drivers/hv/hv_snapshot.c                  |   5 -
 drivers/hv/vmbus_drv.c                    |  10 +-
 drivers/net/hyperv/netvsc.c               |  20 +--
 drivers/scsi/storvsc_drv.c                |  53 ++------
 include/clocksource/hyperv_timer.h        |   6 -
 include/linux/hyperv.h                    |   5 +-
 net/vmw_vsock/hyperv_transport.c          |   3 -
 15 files changed, 76 insertions(+), 282 deletions(-)

-- 
2.25.1

