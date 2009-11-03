From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 3 Nov 2009 12:04:20 -0700
Message-ID: <20091103190420.GY10555@parisc-linux.org>
References: <1257273488.9427.27.camel@mulgrave.site> <20091103105921.160d5599.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753811AbZKCTER@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091103105921.160d5599.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


 static inline void strsrip_tail(char *str)
 {
-	char *x __used;
-	x = strstrip(str);
+	char *x = strstrip(str);
+	BUG_ON(x != str);
 }

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
