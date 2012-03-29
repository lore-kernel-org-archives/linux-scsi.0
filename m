From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: linux-next: recent scsi patches causing 2 warnings per compiled file
Date: Wed, 28 Mar 2012 20:16:03 -0400
Message-ID: <CAP=VYLoXHVrFnKyRjG3sSgosqRs69pme9B=8r4H-uwb=3_2XaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

I just noticed that the alpha (and probably other arch?) are now
getting two warnings per file compiled, which is kind of ugly.

Here is where it transitioned:

good: Mar 24:  http://kisskb.ellerman.id.au/kisskb/buildresult/5941020/

bad: Mar 26: http://kisskb.ellerman.id.au/kisskb/buildresult/5968296/

Screens and screens of these appear:

drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM" is not defined
drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM_MODULE"
is not defined

Missing an include of linux/pm.h or similar, I'd guess.  Can you have
a look please?

Thanks,
Paul.
