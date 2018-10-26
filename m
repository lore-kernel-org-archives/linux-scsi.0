From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 14:30:37 -0700
Message-ID: <1540589437.66186.124.camel@acm.org>
References: <20180930205448.26205-1-natechancellor@gmail.com>
         <10b12992-3570-4646-374b-82cbd7276839@acm.org>
         <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
         <1538503063.193396.6.camel@acm.org>
         <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
         <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
         <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
         <20181025225548.GA10326@flashbox>
         <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
         <1540576908.66186.103.camel@acm.org>
         <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, ooo@electrozaur.com
Cc: Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-10-26 at 14:00 -0700, Nick Desaulniers wrote:
+AD4 On Fri, Oct 26, 2018 at 11:01 AM Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4 wrote:
+AD4 +AD4 
+AD4 +AD4 On Fri, 2018-10-26 at 10:54 -0700, Nick Desaulniers wrote:
+AD4 +AD4 +AD4 If creating one instance of this variable is a functional change, I
+AD4 +AD4 +AD4 can't help but suspect the original code was wrong.  But maybe Bart,
+AD4 +AD4 +AD4 Boaz, or Christoph can clarify or have more thoughts on this?  Looks
+AD4 +AD4 +AD4 like Boaz added this header in commit de258bf5e638 (+ACIAWw-SCSI+AF0 libosd:
+AD4 +AD4 +AD4 OSDv1 Headers+ACI).
+AD4 +AD4 
+AD4 +AD4 Hi Nick and Nathan,
+AD4 +AD4 
+AD4 +AD4 Had you noticed the following e-mail from early October:
+AD4 +AD4 https://marc.info/?l+AD0-linux-kernel+ACY-m+AD0-153849955503249?
+AD4 
+AD4 From this subthread with Linus, removal of the exofs fs and scsi osd
+AD4 code would be a user visible change and is not an option. See:
+AD4 https://lkml.org/lkml/2018/10/27/3
+AD4 https://lkml.org/lkml/2018/10/27/44

Hi Nick,

Linus wrote that removing a filesystem is considered a userspace breakage
if a user notices. The key part is +ACI-if a user notices+ACI. Who are the exofs
users?

Bart.
