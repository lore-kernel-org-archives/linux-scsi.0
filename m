From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Date: Fri, 18 Jun 2010 11:38:41 -0700
Message-ID: <4C1BBD31.8010609@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com> <20100618102330.29eccb5b@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20100618102330.29eccb5b@virtuousgeek.org>
Sender: linux-pci-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-scsi@vger.kernel.org

 From b07231ddb853e9388cea77a82da210e36ab79aad Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Fri, 18 Jun 2010 11:32:20 -0700
Subject: [PATCH 2/2] setup-bus_test
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/pci/setup-bus.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 19b1113..7b57dd0 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -875,6 +875,7 @@ again:
  	pci_bus_size_bridges(parent);
  	__pci_bridge_assign_resources(bridge, &head);
  	retval = pci_reenable_device(bridge);
+	printk(KERN_DEBUG "PCI%d: re-enabling device\n", retval);
  	pci_set_master(bridge);
  	pci_enable_bridges(parent);

-- 
1.7.1.rc1.21.gf3bd6


o.k. I went through this as you had requested to the best of my 
knowledge(bit confused with this, but will try).

let me know if more should be added and/or it's totally wrong
then I'll try again until correct..

Justin P. Mattock
