Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61D22FA0C6;
	Wed, 30 Sep 2026 02:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736500; cv=fail; b=ksU9PHE1GpLe11zS2AJ8zUdFcGebDI+u8Kl4pH8ohoHeN/K+ayIU0ZLslg9DF+6MabwoqdByywOXCgcJR/C658+s7aYDr3z8IW5pV7BdYz/R6G98E+ghtSL01UdXNRPxiaUb4TizyUkOr1YbgTZwI+XUadjw7iGdH2KGk9FKa9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736500; c=relaxed/simple;
	bh=dJC3zQqN+zQ/cMFcWIX+Xs/FVR1NTvwqX8fO1RoS82M=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=egY20P3V/Xx3n8zqS9esoKtDSbk+KMNac+Z26JnhDlazm2/SQ4LlLmfMQxZEeZVNtO7h7iVKhHD82GnDk9aw6GlqmzWVXbPZoPCKn7QW6OC0NBBV1H28kY/TVwBe8RSG72wCfDuhBpIAfySoL1cy+F5Ned87xg+HwHz6Cb4VC8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tu6+JUXU; arc=fail smtp.client-ip=52.101.193.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tu6+JUXU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNjcRg9UJkRgeoi5ppprQ8PJ7ikZkfIPGTRLA0nVEXqP1I7uyVy1yveGG7T0E8p/+XbI4T7z9YJGNeZ+Ki5d6t3Fex52VrMiQYh4NeB0fxR2pIGFohh2v8OToWZ31sBiLZs3WZ6UqNmxyIilZ/N3EmCZoToKEG5nJKmVurVlyXuJ5FvwnLqsKQL6Y0z3bYeWo7CZ1PaMRK5LAI1wMKexhyAmUL/pYLyKgyP+OlFW+8cxcA45sF1qbOHyIbWh1SxDXRxopyAW4v+6I2fxXts3Ff+8mMXTkhEiT2HpRp/vDHyMPQC7bs4RRAn0ExdgmQYrJQY173TAipyUrPDl0Sbk4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOmTsrE1ZA+D3WCB/+AClNpEXh2Jx/U4snuhkho+qaI=;
 b=R4hg8uRGGqo/hA0KgNR+tmZuWyhocLZ69dpLBR3/6UUzKyUOwR7+ac/jfs/YED2rBoVAH2M9xre3ifbxMS48Rj8UQ8kiwXjU4w8wdrXy/2Kf0JTkdIbt6MCQ6RfDdrtAgyReyafTOeHoZG6oGmJQfcDJdkvPIni8f5isGvEOmOSUGAzgRa7CdGS5KH/vdQ8BEr4T6jjCAv/KRG5NgS2CV+JB3o6vldgY1PvAWlhrUcuIZDGh3tOIe0Afkl5ZA23IsCRunryTYFGhHt5CsrEuc7UKmqtqQJ1DmTTP21riym1/4Sh+vhe6R/iw3wkg9R07rt2Fs2t+o+hJGGqSSbBezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOmTsrE1ZA+D3WCB/+AClNpEXh2Jx/U4snuhkho+qaI=;
 b=Tu6+JUXUF/KQi+0Bn4CpdFaHVVBdBn41lRUJYi4aZySFXoqaM+qlTuT6AFgqGs8TwbFxcSNJ4f+X8QZ9CnW2kE/Umz6vaVR4yd4q33NDUwJO1NmTYjEhcRGnPN6xRQsF9Rcn6YhYGWKD2If9Afwyu41Yxr3jzPh9iQqzFTELYVNHrLI6OSyGrxGXJl1IZSNCmsnJ4vdXqm0lqPEkSY07NmDqXx3EwSolZ5NZMXkxNltxF/uPTe5KUMJGKaWbMuMU2Oeo063NzM0lx2GuOAUM1P5GOLaDCD6u1Ow5Odn4w2T+B0vlpKMeF4bjpGOQK65IeNbLT3kUR5tRs83XVo3DYg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Wed, 30 Sep
 2026 02:48:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:48:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:48:02 -0400
Message-Id: <DLSB3REYMCMP.3F5MN6UQTIP30@nvidia.com>
Subject: Re: [PATCH v3 37/40] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-sound@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <sparclinux@vger.kernel.org>, <fuse-devel@lists.linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Stephen Smalley"
 <stephen.smalley.work@gmail.com>, "Jaroslav Kysela" <perex@perex.cz>,
 "Takashi Iwai" <tiwai@suse.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Doug
 Gilbert" <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter"
 <simona@ffwll.ch>, "Helge Deller" <deller@gmx.de>, "Sebastian Reichel"
 <sre@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu"
 <peterx@redhat.com>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "Arnaldo Carvalho de Melo"
 <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent Guittot"
 <vincent.guittot@linaro.org>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "David Airlie"
 <airlied@gmail.com>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Marc Zyngier"
 <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, "Andreas Larsson" <andreas@gaisler.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, "Xu Xin"
 <xu.xin@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0180.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: f2b5b8dd-d8e5-4314-d977-08df1e9d436c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|6133799003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0U7/m/Xru/QpjlaGGaK+dAC+Vkwn8nh5csqxlflv6N5ooavArQuLAPiQgIsBgo26Crls0hU6RW5coeGZ7jducYKwKrr0tFhrJPWHoxOk4dkB9+b5acq4GK7F2VYh5uUHnjlN2cPqNXJ4c5Nvv+mvdsUHdWX9cW7c/RF5QDmFfT9Kdbf2+2Vfqdp3eCF7bsvC/fULpXPX54qdqv78cDJN84x1yCiLv77O1mDDlocv94mX4CrH0KX8hkdN60zWJNnbOYTMR0F6wnA1R/qcow/SVeu29VzG6ZDrbNXOKDWfggX//2kZ4u3eQvi9nUbuHTJ7KXf/ngF4viN4G19ojUbUbYc0WEcz5/woh4kSkGIZ3ApdIJwxZMMv2aX7KhlU5UphacKeO59DZypTkJwCyXbRgNlaXPEX/DtbZET/AcnQOmnbDSzOCpo6txrGgH6eJmNvls3FHm16Q0IoimeYl0ztvts8Ri04maGOdn9sS1ZpFyTPSc1JmVTGTx9NDmxGxjLZW//wm/pnzlgJIR+fcMYjo/qKZTfOaeQvtIrNMyfAFYV0LGSqNsTv1kxAsJ2S9Gv9Gc4jNawl9dSnp6gzBvG2lxvh+KvpKe/CmnusIOSBmBPH2Kfo7RDSbGifXFS6Nz+qGeLLA+IpUxxyN7qlrJ5RgRfWvG5ROnKw6PZ6IhWRnT1VUu6onECtEWuL+L9bNDCz/Yp78xJ1UJQYsv6CCiBEBQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmJiaFFMWElOb1ZoOFJlOC9NSUIvMndhbzlTOVVvVlNET3pZeUsySXZ3K29B?=
 =?utf-8?B?OXJNMTYyNVMyc08xUnBac3JvQVUvTXFJbFpWdGF6clpNb3prNTA3NVFlNFIx?=
 =?utf-8?B?TmVuRmxSRGo1U2pkSUQrOFNnT0wwQTVIWnBWbGxsd3h1biswQk9nWnlpRmpa?=
 =?utf-8?B?VWVidGhKbVhHeXh3Sk5kZm96YThrNitKbEc1bG1JZVBxNFRyd2pTV2cySVJ6?=
 =?utf-8?B?a0EyY2J3azJNeHgvTzIxalpmajJhbVZ2OUtPOG5GRjJhSmVDR3g3a3hPUUly?=
 =?utf-8?B?MmdtajcvUVR1KzRwQitTMmJac2ZqVmRtUXd3STh4ZmFTY2wzc0Z0T3BGUjJQ?=
 =?utf-8?B?dXR0T1FXZ2l5RW4vaCtRa05wMXFhT1lzUHlJVHptT3laTFJDazRZc3dFb09X?=
 =?utf-8?B?cXZod2k5dkl0bDhLWU5wSWxNelp6Q0pvcjFjUk83UmRoZDZxUExNOVplZ0w4?=
 =?utf-8?B?TXRUUUV4ZmRaV0ExWTlkanpXbVBkTVVKeW1HZFhGZmxkblNzSmtYbWdabGZR?=
 =?utf-8?B?VzdTM1Y5cWJwNW92RE5DY29ub00wbFk3SHdhNWJWa2ZmenJsNVFldjFiK0pv?=
 =?utf-8?B?RzhwVFYzL2w0R2J0SjYrWmg4ZmRJb3JBQUFjWkJGeWNYTTAxVUprMDdKZlRp?=
 =?utf-8?B?RlllVVJRcUR1WnZkcnZOLzFqbzJkcytOMU1zZ2RnK003bW81b0wxSjgwU2NP?=
 =?utf-8?B?U3NIOWVzeVhvKzBKNklZWFFBNVFHRDMxdEpqOXFjUVpKeEoyRFZjSmNIS3g0?=
 =?utf-8?B?ZXoxNnN3MlBMMFI3c3FKNHJYWGlPM3FBSUQ3VlRWYUllZ3c0Zm5qWThydHJQ?=
 =?utf-8?B?N2I3UVZJVHFuTU9ZVmtGRVdJL2RiemxWQnBaODNZd1lqV0VSNW5RcmFtWUtY?=
 =?utf-8?B?YWlxL0ZncVlPcjhiSVg1NEw3RFkvSkY5UkdUR1liNGlvSWRucXhyY2Q5a1JW?=
 =?utf-8?B?eTQ3ZUlrQjBIK200ME5iYlljck84NHFFNUYwbi96RndsRlV1cWVtM3d3bWdS?=
 =?utf-8?B?aDFTVVpBWEF3NVBNU1BKWHdISnA4dXlKcGJyTHJRKzFpYVBRQXBBM3FNOVM0?=
 =?utf-8?B?ZEVqb1ZhZUd2aEJQcE52VlZUOGNzUzBuRHJYKzhJUW5UejdHRWlmdGszamRY?=
 =?utf-8?B?YTh2ZHZBdGt4MmsxRlkvWEtTTzdPRWE0V25sNE82RnhBTXh2cW8vSXUwYy8y?=
 =?utf-8?B?S3hsQW9VUUd4YzhDcWRLNzVxeTBMYTVBbUFpRlFCVXhLNW1vanN2WWE5L2Yr?=
 =?utf-8?B?aE80VmJ5TndGWWlzUHNBRllIa0N3eG1ZNjVYbE52RW9oSUJWNnpZUitVT1pO?=
 =?utf-8?B?UUtBNkgrQ2FQRlY0ek0xUFczMFROcDJJNUlxRzgyQkNHa3ZBNzZSNHB6RVAr?=
 =?utf-8?B?TzJEOXdlV0FudXM4bUxDZkM0Mmo0THVuVXRodVV3YVc4c2NvOVFSallVTWoz?=
 =?utf-8?B?SGFLdXp0RHhZblVXbUdSRzlZcEJLeDZSa1BzcjZOMHFXWXRUaHpGZEhtb3g3?=
 =?utf-8?B?b2d2LzZicGo0cFdOelI4UGJ3UXJYOFlXL3d3c1puZ3N5cWRjdUpMclkvek9m?=
 =?utf-8?B?d2dRM1d0NGlRZXFnUjYvR1hVTmsrallvRWk2R2c0M256NnNYWVYyZEFuM1M4?=
 =?utf-8?B?NVR4d1hrVGQzYTlsM05Ra2pLM0pIUFNBTUxHMWhsd3ZUeUdWVTh3NE5yU0Iz?=
 =?utf-8?B?UHpYL3VRSi80YTlzQ3R3cDdyNzJ4czNoS3RnRkNDcXByQzBLNFZTcHU0VEto?=
 =?utf-8?B?ZFY1V0QrNElFVFRzUzB5QWJtUlB5RlhVSjlBclBjelU5NlNGWkFNR1p0d1pV?=
 =?utf-8?B?dDBLL3A2VXBzMGRvZi9NU1VIaGNrRVo5L2liSDRQbW1IdHNEWEhyZ3ZWYjRX?=
 =?utf-8?B?em5ZV2FsNEM1MEhOL3FKK3dQMHJDaGt5Sk8rQjlrakE2cnFTbGFWdHNWekZx?=
 =?utf-8?B?RUhaQlc3QW1CRXprYzd5ek1KVXA4ek9LWCtEVkNyZjlMcWRCUHM1L1U4QVV2?=
 =?utf-8?B?VTg4U25MZ2FWYS9XNGJDazlIbjNBOHZFZklnSFF0aGxxcFN2dmUzdG5YSUFr?=
 =?utf-8?B?UHpHQ0dWbm9VMTVDY0w5NTRwQkJGWkdub1l0SHI0VXpxSkl3cTI4V1daZWNS?=
 =?utf-8?B?ZXMwWGs5Y0l0enVReTFNdnJtQmlhQTdDVnYxWDc5SFFMaFRUTzRJSllEeDg4?=
 =?utf-8?B?b0lxMGRtNFc2QWpNMEU1L3FRZkx5a0tOWXQ5RzZ1bDJrRnRJTmFZWkhjYit0?=
 =?utf-8?B?Z29uc0h3ZXFkaG54Ris1K0pzV1ZDRkZrRmJnV1dXdksyWGUzZElPODJQRERN?=
 =?utf-8?Q?0K4zxUb4WseHyV5MCV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b5b8dd-d8e5-4314-d977-08df1e9d436c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:48:10.1222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okelll0da+4GEaobXjV0FRORy6fDtWWJstHAP/ipoZgRheZaJU41ti+YH0Vj7ETn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted =
to
> predicates which explicitly express what is actually being checked for
> rather than the nebulous concept of possessing 'special' VMA flags.
>
> In any case 'special' is not so special a term of art in mm - it includes
> VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probabl=
y
> other cases too.
>
> Therefore make things less special by eliminating these now unused flags.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 8 --------
>  tools/testing/vma/include/dup.h | 8 --------
>  2 files changed, 16 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

