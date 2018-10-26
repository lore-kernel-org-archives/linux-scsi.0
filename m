From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 11:01:48 -0700
Message-ID: <1540576908.66186.103.camel@acm.org>
References: <20180930205448.26205-1-natechancellor@gmail.com>
         <10b12992-3570-4646-374b-82cbd7276839@acm.org>
         <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
         <1538503063.193396.6.camel@acm.org>
         <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
         <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
         <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
         <20181025225548.GA10326@flashbox>
         <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
Cc: ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-10-26 at 10:54 -0700, Nick Desaulniers wrote:
+AD4 If creating one instance of this variable is a functional change, I
+AD4 can't help but suspect the original code was wrong.  But maybe Bart,
+AD4 Boaz, or Christoph can clarify or have more thoughts on this?  Looks
+AD4 like Boaz added this header in commit de258bf5e638 (+ACIAWw-SCSI+AF0 libosd:
+AD4 OSDv1 Headers+ACI).

Hi Nick and Nathan,

Had you noticed the following e-mail from early October:
https://marc.info/?l+AD0-linux-kernel+ACY-m+AD0-153849955503249?

Thanks,

Bart.
