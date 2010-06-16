From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 0/5] Fix set but unused variable warnings
Date: Tue, 15 Jun 2010 22:33:49 -0700
Message-ID: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Here is another set of patches fixing some warning messages generated 
when building the kernel when using gcc 4.6.0.

This set just focuses in on the variables warnings that are reported
to be unused. Keep in mind there are still lots more warning messages
that I'm seeing, and will try my hardest to see if I can come up with
a fix, but if things become too difficult and so forth then a bug should
be filled etc..
 
And lastly I want to Thank the people who helped me out on the last patch
set I had sent out and so forth.
Please look if you have the time, and let me know.

Thanks!!

Justin P. Mattock
