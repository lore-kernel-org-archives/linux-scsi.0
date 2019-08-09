From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 0/1] kbuild: Support building a tree of modules with -M=<root>
Date: Thu,  8 Aug 2019 19:21:03 -0500
Message-ID: <20190809002104.18599-1-stancheff@cray.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Shaun Tancheff <stancheff@cray.com>, linux-kbuild@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, "'James E . J . Bottomley'" <jejb@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>, "'Martin K . Petersen'" <martin.petersen@oracle.com>, Michal Marek <michal.lkml@markovi.net>, Shuah Khan <shuah@kernel.org>, Thomas Renninger <trenn@suse.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently when building lustre against 5.3 kernel modules fail to
generate <module>.ko files.

Lustre builds a tree of modules however the numerous modules.order files
are created but only the modules.order file at the root appears to be 
read.

This changes the the scheme for KBUILD_EXTMOD to write to and read from
a single modules.order file at the root.

Shaun Tancheff (1):
  kbuild: recursive build of external kernel modules

 Makefile               | 1 +
 scripts/Makefile.build | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.20.1
